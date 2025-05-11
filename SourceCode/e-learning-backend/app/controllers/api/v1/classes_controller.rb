# app/controllers/api/v1/classes_controller.rb
module Api
  module V1
    class ClassesController < Api::BaseController
      before_action :require_admin_schools

      def index
        classes = Class.where(school_id: @current_user.school_id).includes(:homeroom_teacher)
        respond_with_collection(classes, include: { homeroom_teacher: { only: [ :name ] } })
      end

      def create
        class_room = Class.new(class_params.merge(school_id: @current_user.school_id))
        if class_room.save
          respond_with_resource(class_room, {}, :created)
        else
          respond_with_errors(class_room.errors.full_messages)
        end
      end

      def update
        class_room = Class.where(school_id: @current_user.school_id).find(params[:id])
        if class_room.update(class_params)
          respond_with_resource(class_room)
        else
          respond_with_errors(class_room.errors.full_messages)
        end
      end

      def destroy
        class_room = Class.where(school_id: @current_user.school_id).find(params[:id])
        class_room.destroy
        respond_with_no_content
      end

      private

      def class_params
        params.permit(:name, :homeroom_teacher_id)
      end

      def model_class
        Class
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
