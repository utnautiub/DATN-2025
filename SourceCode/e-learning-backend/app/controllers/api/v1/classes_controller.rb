module Api
  module V1
    class ClassesController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        classes = Class.where(school_id: @current_user.school_id)
        render json: classes
      end

      def create
        school_class = Class.new(class_params.merge(school_id: @current_user.school_id))
        if school_class.save
          render json: school_class, status: :created
        else
          render json: school_class.errors, status: :unprocessable_entity
        end
      end

      def update
        school_class = Class.find(params[:id])
        if school_class.update(class_params)
          render json: school_class
        else
          render json: school_class.errors, status: :unprocessable_entity
        end
      end

      def destroy
        school_class = Class.find(params[:id])
        school_class.destroy
        head :no_content
      end

      private

      def class_params
        params.permit(:name, :homeroom_teacher_id)
      end
    end
  end
end