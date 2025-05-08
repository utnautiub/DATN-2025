# app/controllers/api/v1/classes_controller.rb
module Api
  module V1
    class ClassesController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        classes = Class.where(school_id: @current_user.school_id).includes(:homeroom_teacher)
        render json: classes.as_json(include: { homeroom_teacher: { only: [:name] } })
      end

      def create
        class_room = Class.new(class_params.merge(school_id: @current_user.school_id))
        if class_room.save
          render json: class_room, status: :created
        else
          render json: { errors: class_room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        class_room = Class.where(school_id: @current_user.school_id).find(params[:id])
        if class_room.update(class_params)
          render json: class_room
        else
          render json: { errors: class_room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        class_room = Class.where(school_id: @current_user.school_id).find(params[:id])
        class_room.destroy
        head :no_content
      end

      private

      def class_params
        params.permit(:name, :homeroom_teacher_id)
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