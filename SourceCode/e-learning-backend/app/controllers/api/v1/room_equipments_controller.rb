# app/controllers/api/v1/room_equipments_controller.rb
module Api
  module V1
    class RoomEquipmentsController < Api::BaseController
      before_action :require_admin_schools

      def index
        room_equipments = RoomEquipment.joins(room: :building)
                                      .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                      .includes({ room: :building }, :equipment_items)
        respond_with_collection(room_equipments.as_json(include: {
          room: { include: { building: { only: [ :id, :name ] } }, only: [ :id, :name ] },
          equipment_items: { only: [ :id, :code, :status ] }
        }))
      end

      def create
        room = Room.joins(:building).find_by(id: room_equipment_params[:room_id], buildings: { school_id: @current_user.school_id })
        unless room
          respond_with_errors([ "Room not found or does not belong to your school" ])
          return
        end

        room_equipment = RoomEquipment.new(room_equipment_params.except(:quantity))
        room_equipment.quantity = room_equipment_params[:quantity] || 1

        if room_equipment.save
          respond_with_resource(room_equipment.as_json(include: {
            room: { include: { building: { only: [ :id, :name ] } }, only: [ :id, :name ] },
            equipment_items: { only: [ :id, :code, :status ] }
          }), {}, :created)
        else
          respond_with_errors(room_equipment.errors.full_messages)
        end
      end

      def update
        room_equipment = RoomEquipment.joins(room: :building)
                                     .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                     .find(params[:id])
        if room_equipment.update(room_equipment_params.except(:quantity))
          respond_with_resource(room_equipment.as_json(include: {
            room: { include: { building: { only: [ :id, :name ] } }, only: [ :id, :name ] },
            equipment_items: { only: [ :id, :code, :status ] }
          }))
        else
          respond_with_errors(room_equipment.errors.full_messages)
        end
      end

      def destroy
        room_equipment = RoomEquipment.joins(room: :building)
                                     .where(rooms: { buildings: { school_id: @current_user.school_id } })
                                     .find(params[:id])
        room_equipment.destroy
        respond_with_no_content
      end

      private

      def room_equipment_params
        params.permit(:room_id, :name, :quantity)
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
