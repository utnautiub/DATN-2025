# app/controllers/api/v1/subjects_controller.rb
module Api
  module V1
    class SubjectsController < Api::BaseController
      before_action :require_admin_schools

      def index
        subjects = Subject.where(school_id: @current_user.school_id)
        respond_with_collection(subjects)
      end

      def create
        subject = Subject.new(subject_params.merge(school_id: @current_user.school_id))
        if subject.save
          respond_with_resource(subject, {}, :created)
        else
          respond_with_errors(subject.errors.full_messages)
        end
      end

      def update
        subject = Subject.where(school_id: @current_user.school_id).find(params[:id])
        if subject.update(subject_params)
          respond_with_resource(subject)
        else
          respond_with_errors(subject.errors.full_messages)
        end
      end

      def destroy
        subject = Subject.where(school_id: @current_user.school_id).find(params[:id])
        subject.destroy
        respond_with_no_content
      end

      private

      def subject_params
        params.permit(:name, :code, :description)
      end

      def model_class
        Subject
      end
    end
  end
end
