# app/controllers/api/v1/teachers_controller.rb
module Api
  module V1
    class TeachersController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        teachers = Teacher.where(school_id: @current_user.school_id).includes(:user)
        render json: teachers.as_json(include: { user: { only: [:id, :username] } })
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