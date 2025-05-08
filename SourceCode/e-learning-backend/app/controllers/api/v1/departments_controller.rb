# app/controllers/api/v1/departments_controller.rb
module Api
  module V1
    class DepartmentsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        departments = Department.where(school_id: @current_user.school_id)
        render json: departments
      end

      def create
        department = Department.new(department_params.merge(school_id: @current_user.school_id))
        if department.save
          render json: department, status: :created
        else
          render json: { errors: department.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        department = Department.where(school_id: @current_user.school_id).find(params[:id])
        if department.update(department_params)
          render json: department
        else
          render json: { errors: department.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        department = Department.where(school_id: @current_user.school_id).find(params[:id])
        department.destroy
        head :no_content
      end

      private

      def department_params
        params.permit(:name, :code)
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