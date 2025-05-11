module Api
  module V1
    class BuildingsController < Api::BaseController
      before_action :require_admin_schools

      def index
        buildings = Building.where(school_id: @current_user.school_id)
        respond_with_collection(buildings)
      end

      def create
        building = Building.new(building_params.merge(school_id: @current_user.school_id))
        if building.save
          respond_with_resource(building, {}, :created)
        else
          respond_with_errors(building.errors.full_messages)
        end
      end

      def update
        building = Building.where(school_id: @current_user.school_id).find(params[:id])
        if building.update(building_params)
          respond_with_resource(building)
        else
          respond_with_errors(building.errors.full_messages)
        end
      end

      def destroy
        building = Building.where(school_id: @current_user.school_id).find(params[:id])
        building.destroy
        respond_with_no_content
      end

      private

      def building_params
        params.permit(:name, :latitude, :longitude)
      end

      def model_class
        Building
      end
    end
  end
end
