# app/controllers/api/v1/rooms_controller.rb
module Api
  module V1
    class RoomsController < Api::BaseController
      before_action :require_admin_schools

      def index
        rooms = Room.where(school_id: @current_user.school_id)
        respond_with_collection(rooms)
      end

      def create
        room = Room.new(room_params.merge(school_id: @current_user.school_id))
        if room.save
          respond_with_resource(room, {}, :created)
        else
          respond_with_errors(room.errors.full_messages)
        end
      end

      def update
        room = Room.where(school_id: @current_user.school_id).find(params[:id])
        if room.update(room_params)
          respond_with_resource(room)
        else
          respond_with_errors(room.errors.full_messages)
        end
      end

      def destroy
        room = Room.where(school_id: @current_user.school_id).find(params[:id])
        room.destroy
        respond_with_no_content
      end

      private

      def room_params
        params.permit(:name, :capacity, :building_id)
      end

      def model_class
        Room
      end
    end
  end
end
