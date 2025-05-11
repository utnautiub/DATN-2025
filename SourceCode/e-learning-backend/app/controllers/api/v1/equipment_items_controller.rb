# app/controllers/api/v1/equipment_items_controller.rb
module Api
  module V1
    class EquipmentItemsController < Api::BaseController
      before_action :require_admin_schools

      def index
        equipment_items = EquipmentItem.where(school_id: @current_user.school_id)
        respond_with_collection(equipment_items)
      end

      def create
        equipment_item = EquipmentItem.new(equipment_item_params.merge(school_id: @current_user.school_id))
        if equipment_item.save
          respond_with_resource(equipment_item, {}, :created)
        else
          respond_with_errors(equipment_item.errors.full_messages)
        end
      end

      def update
        equipment_item = EquipmentItem.where(school_id: @current_user.school_id).find(params[:id])
        if equipment_item.update(equipment_item_params)
          respond_with_resource(equipment_item)
        else
          respond_with_errors(equipment_item.errors.full_messages)
        end
      end

      def destroy
        equipment_item = EquipmentItem.where(school_id: @current_user.school_id).find(params[:id])
        equipment_item.destroy
        respond_with_no_content
      end

      private

      def equipment_item_params
        params.permit(:name, :code, :status)
      end

      def model_class
        EquipmentItem
      end
    end
  end
end
