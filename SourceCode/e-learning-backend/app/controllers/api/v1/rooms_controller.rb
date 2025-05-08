# app/controllers/api/v1/rooms_controller.rb
module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        rooms = Room.joins(:building).where(buildings: { school_id: @current_user.school_id }).includes(:building)
        render json: rooms.as_json(include: { building: { only: [:id, :name] } })
      end

      def create
        # Kiểm tra xem building_id có thuộc về trường của @current_user không
        building = Building.find_by(id: room_params[:building_id], school_id: @current_user.school_id)
        unless building
          render json: { error: 'Building not found or does not belong to your school' }, status: :unprocessable_entity
          return
        end

        room = Room.new(room_params)
        if room.save
          render json: room.as_json(include: { building: { only: [:id, :name] } }), status: :created
        else
          render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        room = Room.joins(:building).where(buildings: { school_id: @current_user.school_id }).find(params[:id])
        if room.update(room_params)
          render json: room.as_json(include: { building: { only: [:id, :name] } })
        else
          render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        room = Room.joins(:building).where(buildings: { school_id: @current_user.school_id }).find(params[:id])
        room.destroy
        head :no_content
      end

      private

      def room_params
        params.require(:room).permit(:building_id, :name, :capacity)
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