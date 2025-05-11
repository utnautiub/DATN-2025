# app/controllers/api/v1/enrollments_controller.rb
module Api
  module V1
    class EnrollmentsController < Api::BaseController
      before_action :require_admin_schools, only: [ :index, :destroy ]
      before_action :check_student_authorization, only: [ :create ]

      def index
        enrollments = Enrollment.joins(student: { class: :school })
                               .where(classes: { school_id: @current_user.school_id })
                               .includes(:student, :course)
        respond_with_collection(enrollments, include: { student: { only: [ :name ] }, course: { only: [ :name ] } })
      end

      def create
        enrollment = Enrollment.new(enrollment_params)
        if enrollment.save
          respond_with_resource(enrollment, {}, :created)
        else
          respond_with_errors(enrollment.errors.full_messages)
        end
      end

      def destroy
        enrollment = Enrollment.joins(student: { class: :school })
                              .where(classes: { school_id: @current_user.school_id })
                              .find(params[:id])
        enrollment.destroy
        respond_with_no_content
      end

      private

      def enrollment_params
        params.permit(:student_id, :course_id)
      end

      def check_student_authorization
        # AdminSchools có thể tạo enrollment cho bất kỳ học sinh nào trong trường
        return true if @current_user.role == "AdminSchools"

        # Học sinh chỉ có thể tạo enrollment cho chính mình
        if @current_user.role == "Student"
          student = Student.find_by(user_id: @current_user.id)
          unless student && student.id.to_s == params[:student_id].to_s
            respond_with_errors("Bạn không có quyền đăng ký cho học sinh khác", :forbidden)
            return false
          end
        else
          respond_with_errors("Bạn không có quyền thực hiện hành động này", :forbidden)
          return false
        end

        true
      end

      def model_class
        Enrollment
      end
    end
  end
end
