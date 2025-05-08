# app/controllers/api/v1/enrollments_controller.rb
module Api
  module V1
    class EnrollmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        enrollments = Enrollment.joins(student: { class: :school })
                               .where(classes: { school_id: @current_user.school_id })
                               .includes(:student, :course)
        render json: enrollments.as_json(include: { student: { only: [:name] }, course: { only: [:name] } })
      end

      def create
        enrollment = Enrollment.new(enrollment_params)
        if enrollment.save
          render json: enrollment, status: :created
        else
          render json: { errors: enrollment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        enrollment = Enrollment.joins(student: { class: :school })
                              .where(classes: { school_id: @current_user.school_id })
                              .find(params[:id])
        enrollment.destroy
        head :no_content
      end

      private

      def enrollment_params
        params.permit(:student_id, :course_id)
      end

      def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        begin
          decoded = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
          @current_user = User.find(decoded[0]['user_id'])
        rescue
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def require_admin_schools
        render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.role == 'AdminSchools'
      end
    end
  end
end