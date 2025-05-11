# app/controllers/api/v1/departments_controller.rb
module Api
  module V1
    class DepartmentsController < Api::BaseController
      before_action :require_admin_schools

      def index
        departments = Department.where(school_id: @current_user.school_id)
        respond_with_collection(departments)
      end

      def create
        department = Department.new(department_params.merge(school_id: @current_user.school_id))
        if department.save
          respond_with_resource(department, {}, :created)
        else
          respond_with_errors(department.errors.full_messages)
        end
      end

      def update
        department = Department.where(school_id: @current_user.school_id).find(params[:id])
        if department.update(department_params)
          respond_with_resource(department)
        else
          respond_with_errors(department.errors.full_messages)
        end
      end

      def destroy
        department = Department.where(school_id: @current_user.school_id).find(params[:id])
        department.destroy
        respond_with_no_content
      end

      private

      def department_params
        params.permit(:name, :description)
      end

      def model_class
        Department
      end

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
