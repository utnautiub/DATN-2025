# app/controllers/api/v1/training_program_subjects_controller.rb
module Api
  module V1
    class TrainingProgramSubjectsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        training_program_subjects = TrainingProgramSubject.joins(training_program: { major: :department })
                                                         .where(training_programs: { majors: { departments: { school_id: @current_user.school_id } } })
                                                         .includes({ training_program: { major: :department } }, :subject)
        render json: training_program_subjects.as_json(include: { 
          training_program: { include: { major: { include: { department: { only: [:name] } }, only: [:name] } }, only: [:name] }, 
          subject: { only: [:name] }
        })
      end

      def create
        training_program_subject = TrainingProgramSubject.new(training_program_subject_params)
        if training_program_subject.save
          render json: training_program_subject, status: :created
        else
          render json: { errors: training_program_subject.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        training_program_subject = TrainingProgramSubject.joins(training_program: { major: :department })
                                                        .where(training_programs: { majors: { departments: { school_id: @current_user.school_id } } })
                                                        .find(params[:id])
        training_program_subject.destroy
        head :no_content
      end

      private

      def training_program_subject_params
        params.permit(:program_id, :subject_id, :semester)
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