# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_or_super_admin

      def index
        if @current_user.role == 'SuperAdmin'
          users = User.where(role: 'AdminSchools').includes(:school)
        else
          users = User.where(school_id: @current_user.school_id).where.not(role: 'SuperAdmin').includes(:school)
        end
        render json: users.as_json(include: { school: { only: [:id, :name] } }, except: [:password_digest])
      end

      def create
        user = User.new(user_params.merge(school_id: @current_user.school_id))
        if user.save
          render json: user.as_json(include: { school: { only: [:id, :name] } }, except: [:password_digest]), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def create_admin_account
        school = School.find(params[:school_id])
        user = User.new(user_params.merge(school_id: school.id, role: 'AdminSchools'))
        if user.save
          render json: user.as_json(include: { school: { only: [:id, :name] } }, except: [:password_digest]), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params.except(:password))
          if user_params[:password].present?
            user.password = user_params[:password]
            user.save
          end
          render json: user.as_json(include: { school: { only: [:id, :name] } }, except: [:password_digest])
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        # Chỉ Super Admin mới được xóa tài khoản AdminSchools
        if user.role == 'AdminSchools' && @current_user.role != 'SuperAdmin'
          render json: { error: 'Forbidden: Only Super Admin can delete Admin Schools accounts' }, status: :forbidden
          return
        end
        # AdminSchools không được xóa chính mình
        if user.id == @current_user.id && @current_user.role == 'AdminSchools'
          render json: { error: 'Forbidden: Cannot delete your own account' }, status: :forbidden
          return
        end
        user.destroy
        head :no_content
      end

      private

      def user_params
        params.permit(:username, :password, :role, :admin_level, :google_access_token, :google_refresh_token, :google_token_expiry)
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

      def require_admin_or_super_admin
        render json: { error: 'Forbidden' }, status: :forbidden unless ['SuperAdmin', 'AdminSchools'].include?(@current_user.role)
      end
    end
  end
end