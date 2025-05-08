# app/controllers/api/v1/room_equipments_controller.rb
module Api
  module V1
    class RoomEquipmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        room_equipments = RoomEquipment.joins(room: :building)
                                      .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                      .includes({ room: :building }, :equipment_items)
        render json: room_equipments.as_json(include: { 
          room: { include: { building: { only: [:id, :name] } }, only: [:id, :name] }, 
          equipment_items: { only: [:id, :code, :status] } 
        })
      end

      def create
        # Kiểm tra xem room_id có thuộc về trường của @current_user không
        room = Room.joins(:building).find_by(id: room_equipment_params[:room_id], buildings: { school_id: @current_user.school_id })
        unless room
          render json: { error: 'Room not found or does not belong to your school' }, status: :unprocessable_entity
          return
        end

        room_equipment = RoomEquipment.new(room_equipment_params.except(:quantity))
        room_equipment.quantity = room_equipment_params[:quantity] || 1 # Truyền quantity trực tiếp

        if room_equipment.save
          render json: room_equipment.as_json(include: { 
            room: { include: { building: { only: [:id, :name] } }, only: [:id, :name] }, 
            equipment_items: { only: [:id, :code, :status] } 
          }), status: :created
        else
          render json: { errors: room_equipment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        room_equipment = RoomEquipment.joins(room: :building)
                                     .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                     .find(params[:id])
        if room_equipment.update(room_equipment_params.except(:quantity))
          render json: room_equipment.as_json(include: { 
            room: { include: { building: { only: [:id, :name] } }, only: [:id, :name] }, 
            equipment_items: { only: [:id, :code, :status] } 
          })
        else
          render json: { errors: room_equipment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        room_equipment = RoomEquipment.joins(room: :building)
                                     .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                     .find(params[:id])
        room_equipment.destroy
        head :no_content
      end

      private

      def room_equipment_params
        params.permit(:room_id, :name, :quantity)
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