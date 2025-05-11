module Api
  module V1
    class SchedulesController < Api::BaseController
      before_action :require_admin_schools, only: [ :create, :update, :destroy ]
      before_action :require_teacher_or_admin, only: [ :create_meet_link ]

      def index
        if @current_user.role == "AdminSchools"
          schedules = Schedule.joins(:course).where(courses: { school_id: @current_user.school_id })
        elsif @current_user.role == "Teacher"
          schedules = Schedule.joins(:course).where(courses: { teacher_id: @current_user.teacher.id })
        else
          schedules = Schedule.joins(:course).where(courses: { school_id: @current_user.student.school_id })
        end
        respond_with_collection(schedules)
      end

      def create
        schedule = Schedule.new(schedule_params)
        if schedule.course.mode == "Trực tuyến"
          schedule.meet_link = nil
        end
        if schedule.save
          respond_with_resource(schedule, {}, :created)
        else
          respond_with_errors(schedule.errors.full_messages)
        end
      end

      def update
        schedule = Schedule.find(params[:id])
        if schedule.update(schedule_params)
          respond_with_resource(schedule)
        else
          respond_with_errors(schedule.errors.full_messages)
        end
      end

      def destroy
        schedule = Schedule.find(params[:id])
        schedule.destroy
        respond_with_no_content
      end

      def create_meet_link
        schedule = Schedule.find(params[:id])
        teacher = schedule.course.teacher.user

        unless teacher.google_access_token && teacher.google_token_expiry > Time.now
          respond_with_errors([ "Giáo viên cần liên kết tài khoản Google" ])
          return
        end

        client = Google::Apis::CalendarV3::CalendarService.new
        client.authorization = teacher.google_access_token

        event = Google::Apis::CalendarV3::Event.new(
          summary: "Lớp học #{schedule.course.subject.name} - #{schedule.day_of_week}",
          start: Google::Apis::CalendarV3::EventDateTime.new(date_time: schedule.start_time.rfc3339),
          end: Google::Apis::CalendarV3::EventDateTime.new(date_time: schedule.end_time.rfc3339),
          conference_data: Google::Apis::CalendarV3::ConferenceData.new(
            create_request: Google::Apis::CalendarV3::CreateConferenceRequest.new(
              request_id: SecureRandom.uuid,
              conference_solution_key: { type: "hangoutsMeet" }
            )
          )
        )

        result = client.insert_event("primary", event, conference_data_version: 1)
        schedule.update(meet_link: result.hangout_link)

        respond_with_resource(schedule)
      end

      private

      def schedule_params
        params.permit(:course_id, :class_id, :day_of_week, :start_time, :end_time, :room_id, :status)
      end

      def require_teacher_or_admin
        render json: { error: "Forbidden" }, status: :forbidden unless [ "AdminSchools", "Teacher" ].include?(@current_user.role)
      end
    end
  end
end
