# app/controllers/api/v1/majors_controller.rb
module Api
  module V1
    class MajorsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        majors = Major.joins(:department).where(departments: { school_id: @current_user.school_id }).includes(:department)
        render json: majors.as_json(include: { department: { only: [:name] } })
      end

      def create
        major = Major.new(major_params)
        if major.save
          render json: major, status: :created
        else
          render json: { errors: major.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        major = Major.joins(:department).where(departments: { school_id: @current_user.school_id }).find(params[:id])
        if major.update(major_params)
          render json: major
        else
          render json: { errors: major.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        major = Major.joins(:department).where(departments: { school_id: @current_user.school_id }).find(params[:id])
        major.destroy
        head :no_content
      end

      private

      def major_params
        params.permit(:name, :code, :department_id)
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