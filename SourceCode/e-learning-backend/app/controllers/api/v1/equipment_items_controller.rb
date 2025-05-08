# app/controllers/api/v1/equipment_items_controller.rb
module Api
  module V1
    class EquipmentItemsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def destroy
        equipment_item = EquipmentItem.joins(room_equipment: { room: :building })
                                     .where(room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } })
                                     .find(params[:id])
        equipment_item.destroy
        head :no_content
      end

      private

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