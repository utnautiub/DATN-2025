# app/controllers/api/v1/teachers_controller.rb
module Api
  module V1
    class TeachersController < Api::BaseController
      before_action :require_admin_schools

      def index
        teachers = Teacher.where(school_id: @current_user.school_id).includes(:user)
        respond_with_collection(teachers.as_json(include: { user: { only: [ :id, :username ] } }))
      end

      private

      def require_admin_schools
        render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools"
      end
    end
  end
end
