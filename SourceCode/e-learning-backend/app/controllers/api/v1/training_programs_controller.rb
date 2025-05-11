# app/controllers/api/v1/training_programs_controller.rb
module Api
  module V1
    class TrainingProgramsController < Api::BaseController
      before_action :require_admin_schools

      def index
        training_programs = TrainingProgram.where(school_id: @current_user.school_id)
        respond_with_collection(training_programs)
      end

      def create
        training_program = TrainingProgram.new(training_program_params.merge(school_id: @current_user.school_id))
        if training_program.save
          respond_with_resource(training_program, {}, :created)
        else
          respond_with_errors(training_program.errors.full_messages)
        end
      end

      def update
        training_program = TrainingProgram.where(school_id: @current_user.school_id).find(params[:id])
        if training_program.update(training_program_params)
          respond_with_resource(training_program)
        else
          respond_with_errors(training_program.errors.full_messages)
        end
      end

      def destroy
        training_program = TrainingProgram.where(school_id: @current_user.school_id).find(params[:id])
        training_program.destroy
        respond_with_no_content
      end

      private

      def training_program_params
        params.permit(:name, :description)
      end

      def model_class
        TrainingProgram
      end
    end
  end
end
