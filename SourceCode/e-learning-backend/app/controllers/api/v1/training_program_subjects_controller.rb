# app/controllers/api/v1/training_program_subjects_controller.rb
module Api
  module V1
    class TrainingProgramSubjectsController < Api::BaseController
      before_action :require_admin_schools

      def index
        training_program_subjects = TrainingProgramSubject.joins(training_program: { major: :department })
                                                         .where(training_programs: { majors: { departments: { school_id: @current_user.school_id } } })
                                                         .includes({ training_program: { major: :department } }, :subject)
        respond_with_collection(training_program_subjects.as_json(include: {
          training_program: { include: { major: { include: { department: { only: [ :name ] } }, only: [ :name ] } }, only: [ :name ] },
          subject: { only: [ :name ] }
        }))
      end

      def create
        training_program_subject = TrainingProgramSubject.new(training_program_subject_params)
        if training_program_subject.save
          respond_with_resource(training_program_subject, {}, :created)
        else
          respond_with_errors(training_program_subject.errors.full_messages)
        end
      end

      def destroy
        training_program_subject = TrainingProgramSubject.joins(training_program: { major: :department })
                                                        .where(training_programs: { majors: { departments: { school_id: @current_user.school_id } } })
                                                        .find(params[:id])
        training_program_subject.destroy
        respond_with_no_content
      end

      private

      def training_program_subject_params
        params.permit(:program_id, :subject_id, :semester)
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
