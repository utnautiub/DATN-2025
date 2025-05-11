# app/controllers/api/v1/majors_controller.rb
module Api
  module V1
    class MajorsController < Api::BaseController
      before_action :require_admin_schools

      def index
        majors = Major.where(school_id: @current_user.school_id)
        respond_with_collection(majors)
      end

      def create
        major = Major.new(major_params.merge(school_id: @current_user.school_id))
        if major.save
          respond_with_resource(major, {}, :created)
        else
          respond_with_errors(major.errors.full_messages)
        end
      end

      def update
        major = Major.where(school_id: @current_user.school_id).find(params[:id])
        if major.update(major_params)
          respond_with_resource(major)
        else
          respond_with_errors(major.errors.full_messages)
        end
      end

      def destroy
        major = Major.where(school_id: @current_user.school_id).find(params[:id])
        major.destroy
        respond_with_no_content
      end

      private

      def major_params
        params.permit(:name, :description)
      end

      def model_class
        Major
      end
    end
  end
end
