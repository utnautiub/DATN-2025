# app/controllers/api/v1/schools_controller.rb
module Api
  module V1
    class SchoolsController < Api::BaseController
      before_action :require_super_admin, except: [ :show ]

      def index
        schools = School.all
        respond_with_collection(schools)
      end

      def show
        school = School.find(params[:id])

        # Thêm thông tin chi tiết về trường học
        school_details = school.as_json(
          include: {
            departments: { only: [ :id, :name ] },
            buildings: { only: [ :id, :name, :address ] },
            users: {
              only: [ :id, :username, :role ],
              where: { role: "AdminSchools" }
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
          respond_with_resource(school, {}, :created)
        else
          respond_with_errors(school.errors.full_messages)
        end
      end

      def update
        school = School.find(params[:id])
        if school.update(school_params)
          respond_with_resource(school)
        else
          respond_with_errors(school.errors.full_messages)
        end
      end

      def destroy
        school = School.find(params[:id])
        school.destroy
        respond_with_no_content
      end

      private

      def school_params
        params.permit(:name, :address, :phone, :email)
      end

      def model_class
        School
      end
    end
  end
end
