module Api
  module V1
    class UserGroupsController < Api::BaseController
      before_action :require_admin_schools

      def index
        user_groups = UserGroup.where(school_id: @current_user.school_id).includes(:users)
        respond_with_collection(user_groups.as_json(include: { users: { only: [ :id, :username ] } }))
      end

      def create
        user_group = UserGroup.new(user_group_params.merge(school_id: @current_user.school_id))
        if user_group.save
          respond_with_resource(user_group.as_json(include: { users: { only: [ :id, :username ] } }), {}, :created)
        else
          respond_with_errors(user_group.errors.full_messages)
        end
      end

      def update
        user_group = UserGroup.find(params[:id])
        if user_group.update(user_group_params)
          respond_with_resource(user_group.as_json(include: { users: { only: [ :id, :username ] } }))
        else
          respond_with_errors(user_group.errors.full_messages)
        end
      end

      def destroy
        user_group = UserGroup.find(params[:id])
        user_group.destroy
        respond_with_no_content
      end

      private

      def user_group_params
        params.permit(:name, :description, user_ids: [])
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
