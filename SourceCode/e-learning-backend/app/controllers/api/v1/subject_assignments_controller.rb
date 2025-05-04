module Api
  module V1
    class SubjectAssignmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        subject_assignments = SubjectAssignment.where(school_id: @current_user.school_id)
        render json: subject_assignments
      end

      def create
        subject_assignment = SubjectAssignment.new(subject_assignment_params.merge(school_id: @current_user.school_id))
        if subject_assignment.save
          render json: subject_assignment, status: :created
        else
          render json: subject_assignment.errors, status: :unprocessable_entity
        end
      end

      def update
        subject_assignment = SubjectAssignment.find(params[:id])
        if subject_assignment.update(subject_assignment_params)
          render json: subject_assignment
        else
          render json: subject_assignment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        subject_assignment = SubjectAssignment.find(params[:id])
        subject_assignment.destroy
        head :no_content
      end

      private

      def subject_assignment_params
        params.permit(:subject_id, :teacher_id)
      end
    end
  end
end