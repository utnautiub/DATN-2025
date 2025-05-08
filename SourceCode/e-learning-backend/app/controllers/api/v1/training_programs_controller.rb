# app/controllers/api/v1/training_programs_controller.rb
module Api
  module V1
    class TrainingProgramsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        training_programs = TrainingProgram.joins(major: :department)
                                          .where(majors: { departments: { school_id: @current_user.school_id } })
                                          .includes(major: :department)
        render json: training_programs.as_json(include: { major: { include: { department: { only: [:name] } }, only: [:name] } })
      end

      def create
        training_program = TrainingProgram.new(training_program_params)
        if training_program.save
          render json: training_program, status: :created
        else
          render json: { errors: training_program.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        training_program = TrainingProgram.joins(major: :department)
                                         .where(majors: { departments: { school_id: @current_user.school_id } })
                                         .find(params[:id])
        if training_program.update(training_program_params)
          render json: training_program
        else
          render json: { errors: training_program.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        training_program = TrainingProgram.joins(major: :department)
                                         .where(majors: { departments: { school_id: @current_user.school_id } })
                                         .find(params[:id])
        training_program.destroy
        head :no_content
      end

      private

      def training_program_params
        params.permit(:name, :start_year, :end_year, :major_id)
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