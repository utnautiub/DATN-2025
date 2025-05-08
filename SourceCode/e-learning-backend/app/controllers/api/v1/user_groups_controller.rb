module Api
  module V1
    class UserGroupsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        user_groups = UserGroup.where(school_id: @current_user.school_id).includes(:users)
        render json: user_groups.as_json(include: { users: { only: [:id, :username] } })
      end

      def create
        user_group = UserGroup.new(user_group_params.merge(school_id: @current_user.school_id))
        if user_group.save
          render json: user_group.as_json(include: { users: { only: [:id, :username] } }), status: :created
        else
          render json: user_group.errors, status: :unprocessable_entity
        end
      end

      def update
        user_group = UserGroup.find(params[:id])
        if user_group.update(user_group_params)
          render json: user_group.as_json(include: { users: { only: [:id, :username] } })
        else
          render json: user_group.errors, status: :unprocessable_entity
        end
      end

      def destroy
        user_group = UserGroup.find(params[:id])
        user_group.destroy
        head :no_content
      end

      private

      def user_group_params
        params.permit(:name, :description, user_ids: [])
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