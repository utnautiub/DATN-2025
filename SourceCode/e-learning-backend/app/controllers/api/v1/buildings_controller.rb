module Api
  module V1
    class BuildingsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        buildings = Building.where(school_id: @current_user.school_id)
        render json: buildings
      end

      def create
        building = Building.new(building_params.merge(school_id: @current_user.school_id))
        if building.save
          render json: building, status: :created
        else
          render json: building.errors, status: :unprocessable_entity
        end
      end

      def update
        building = Building.find(params[:id])
        if building.update(building_params)
          render json: building
        else
          render json: building.errors, status: :unprocessable_entity
        end
      end

      def destroy
        building = Building.find(params[:id])
        building.destroy
        head :no_content
      end

      private

      def building_params
        params.permit(:name, :latitude, :longitude)
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