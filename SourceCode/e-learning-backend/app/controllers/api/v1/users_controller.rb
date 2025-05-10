module Api
  module V1
    class UsersController < Api::BaseController
      before_action :require_admin_schools

      def index
        users = current_school_scope

        users = users.where(role: params[:role]) if params[:role].present?

        users = users.includes(
          :school,
          student: { class: [], major: [], training_program: [] },
          teacher: { subjects: [] }
        )

        respond_with_collection(users, include: {
          school: { only: [ :name ] },
          student: { include: { class: { only: [ :name ] }, major: { only: [ :name ] }, training_program: { only: [ :name ] } }, only: [ :student_code ] },
          teacher: { include: { subjects: { only: [ :name ] } }, only: [ :name, :teacher_code ] }
        })
      end

      def create
        service = UserRegistrationService.new(params, @current_user)
        user = service.register

        if user
          respond_with_resource(user, {
            include: {
              school: { only: [ :name ] },
              student: { include: { class: { only: [ :name ] }, major: { only: [ :name ] }, training_program: { only: [ :name ] } }, only: [ :student_code ] },
              teacher: { include: { subjects: { only: [ :name ] } }, only: [ :teacher_code ] }
            }
          }, :created)
        else
          respond_with_errors(service.errors)
        end
      end

      def update
        user = current_school_scope.find(params[:id])

        if user.update(user_params)
          respond_with_resource(user, include: {
            school: { only: [ :name ] },
            student: { include: { class: { only: [ :name ] }, major: { only: [ :name ] }, training_program: { only: [ :name ] } }, only: [ :student_code ] },
            teacher: { include: { subjects: { only: [ :name ] } }, only: [ :teacher_code ] }
          })
        else
          respond_with_errors(user.errors.full_messages)
        end
      end

      def destroy
        user = current_school_scope.find(params[:id])

        # Nếu không phải Super Admin, kiểm tra điều kiện xóa tài khoản Admin Schools
        if @current_user.role != "SuperAdmin" && @current_user.role == "AdminSchools" && user.role == "AdminSchools"
          respond_with_errors("Không thể xóa tài khoản AdminSchools", :forbidden)
        else
          user.destroy
          respond_with_no_content
        end
      end

      def create_admin_account
        unless @current_user.role == "SuperAdmin"
          respond_with_errors("Forbidden", :forbidden)
          return
        end

        school = School.find(params[:school_id])
        user = User.new(user_params.merge(school_id: school.id, role: "AdminSchools"))

        if user.save
          respond_with_resource(user, {
            include: {
              school: { only: [ :name ] },
              student: { include: { class: { only: [ :name ] }, major: { only: [ :name ] }, training_program: { only: [ :name ] } }, only: [ :student_code ] },
              teacher: { include: { subjects: { only: [ :name ] } }, only: [ :teacher_code ] }
            }
          }, :created)
        else
          respond_with_errors(user.errors.full_messages)
        end
      end

      private

      def user_params
        params.permit(:username, :password, :role)
      end

      def model_class
        User
      end
    end
  end
end
