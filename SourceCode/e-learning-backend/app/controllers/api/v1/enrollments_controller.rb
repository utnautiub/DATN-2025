module Api
  module V1
    class EnrollmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_student, only: [:create, :destroy]

      def index
        enrollments = Enrollment.where(student_id: @current_user.student.id)
        render json: enrollments
      end

      def create
        enrollment = Enrollment.new(enrollment_params.merge(student_id: @current_user.student.id))
        if enrollment.save
          render json: enrollment, status: :created
        else
          render json: enrollment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        enrollment = Enrollment.find(params[:id])
        enrollment.destroy
        head :no_content
      end

      private

      def enrollment_params
        params.permit(:course_id)
      end

      def require_student
        render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.role == 'Student'
      end
    end
  end
end