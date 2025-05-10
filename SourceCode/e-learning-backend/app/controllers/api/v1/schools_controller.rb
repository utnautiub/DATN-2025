# app/controllers/api/v1/schools_controller.rb
module Api
  module V1
    class SchoolsController < ApplicationController
      before_action :authenticate_user
      before_action :require_super_admin, except: [:show]

      def index
        schools = School.all
        render json: schools
      end

      def show
        school = School.find(params[:id])
        
        # Thêm thông tin chi tiết về trường học
        school_details = school.as_json(
          include: {
            departments: { only: [:id, :name] },
            buildings: { only: [:id, :name, :address] },
            users: { 
              only: [:id, :username, :role],
              where: { role: 'AdminSchools' }
            }
          }
        )
        
        # Thêm thống kê
        school_details[:stats] = {
          departments_count: school.departments.count,
          buildings_count: school.buildings.count,
          teachers_count: school.teachers.count,
          students_count: school.students.count,
          classes_count: school.school_classes.count, # Đổi từ classes thành school_classes
          courses_count: school.courses.count
        }
        
        render json: school_details
      end

      def create
        school = School.new(school_params)
        if school.save
          render json: school, status: :created
        else
          render json: { errors: school.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        school = School.find(params[:id])
        if school.update(school_params)
          render json: school
        else
          render json: { errors: school.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        school = School.find(params[:id])
        school.destroy
        head :no_content
      end

      private

      def school_params
        params.permit(:name, :address, :phone, :email)
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

      def require_super_admin
        render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.role == 'SuperAdmin'
      end
    end
  end
end
