# app/controllers/api/v1/subject_assignments_controller.rb
module Api
  module V1
    class SubjectAssignmentsController < Api::BaseController
      before_action :require_admin_schools

      def index
        subject_assignments = SubjectAssignment.where(school_id: @current_user.school_id).includes(:subject, :teacher)
        respond_with_collection(subject_assignments.as_json(include: { subject: { only: [ :name ] }, teacher: { only: [ :name ] } }))
      end

      def create
        subject_assignment = SubjectAssignment.new(subject_assignment_params.merge(school_id: @current_user.school_id))
        if subject_assignment.save
          respond_with_resource(subject_assignment, {}, :created)
        else
          respond_with_errors(subject_assignment.errors.full_messages)
        end
      end

      def update
        subject_assignment = SubjectAssignment.where(school_id: @current_user.school_id).find(params[:id])
        if subject_assignment.update(subject_assignment_params)
          respond_with_resource(subject_assignment)
        else
          respond_with_errors(subject_assignment.errors.full_messages)
        end
      end

      def destroy
        subject_assignment = SubjectAssignment.where(school_id: @current_user.school_id).find(params[:id])
        subject_assignment.destroy
        respond_with_no_content
      end

      private

      def subject_assignment_params
        params.permit(:subject_id, :teacher_id)
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
