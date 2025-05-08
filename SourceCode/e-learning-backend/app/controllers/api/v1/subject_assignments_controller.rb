# app/controllers/api/v1/subject_assignments_controller.rb
module Api
  module V1
    class SubjectAssignmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        subject_assignments = SubjectAssignment.where(school_id: @current_user.school_id).includes(:subject, :teacher)
        render json: subject_assignments.as_json(include: { subject: { only: [:name] }, teacher: { only: [:name] } })
      end

      def create
        subject_assignment = SubjectAssignment.new(subject_assignment_params.merge(school_id: @current_user.school_id))
        if subject_assignment.save
          render json: subject_assignment, status: :created
        else
          render json: { errors: subject_assignment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        subject_assignment = SubjectAssignment.where(school_id: @current_user.school_id).find(params[:id])
        if subject_assignment.update(subject_assignment_params)
          render json: subject_assignment
        else
          render json: { errors: subject_assignment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        subject_assignment = SubjectAssignment.where(school_id: @current_user.school_id).find(params[:id])
        subject_assignment.destroy
        head :no_content
      end

      private

      def subject_assignment_params
        params.permit(:subject_id, :teacher_id)
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