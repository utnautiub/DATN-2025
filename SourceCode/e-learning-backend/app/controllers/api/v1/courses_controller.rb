module Api
  module V1
    class CoursesController < Api::BaseController
      before_action :require_admin_schools

      def index
        courses = Course.where(school_id: @current_user.school_id)
        respond_with_collection(courses)
      end

      def create
        course = Course.new(course_params.merge(school_id: @current_user.school_id))
        if course.save
          respond_with_resource(course, {}, :created)
        else
          respond_with_errors(course.errors.full_messages)
        end
      end

      def update
        course = Course.find(params[:id])
        if course.update(course_params)
          respond_with_resource(course)
        else
          respond_with_errors(course.errors.full_messages)
        end
      end

      def destroy
        course = Course.find(params[:id])
        course.destroy
        respond_with_no_content
      end

      private

      def course_params
        params.permit(:subject_id, :teacher_id, :name, :mode)
      end
    end
  end
end
