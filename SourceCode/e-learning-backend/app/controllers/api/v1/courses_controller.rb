module Api
  module V1
    class CoursesController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        courses = Course.where(school_id: @current_user.school_id)
        render json: courses
      end

      def create
        course = Course.new(course_params.merge(school_id: @current_user.school_id))
        if course.save
          render json: course, status: :created
        else
          render json: course.errors, status: :unprocessable_entity
        end
      end

      def update
        course = Course.find(params[:id])
        if course.update(course_params)
          render json: course
        else
          render json: course.errors, status: :unprocessable_entity
        end
      end

      def destroy
        course = Course.find(params[:id])
        course.destroy
        head :no_content
      end

      private

      def course_params
        params.permit(:subject_id, :teacher_id, :name, :mode)
      end
    end
  end
end