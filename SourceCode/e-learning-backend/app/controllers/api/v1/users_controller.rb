# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        users = User.where(school_id: @current_user.school_id)
                    .includes(student: { class: [], major: [], training_program: [] }, teacher: { subjects: [] })
        render json: users.as_json(include: {
          student: { include: { class: { only: [:name] }, major: { only: [:name] }, training_program: { only: [:name] } }, only: [:student_code] },
          teacher: { include: { subjects: { only: [:name] } }, only: [:teacher_code] }
        })
      end

      def create
        user = User.new(user_params.merge(school_id: @current_user.school_id))
        user.role = params[:role] if params[:role].present?

        # Xử lý Student
        if user.role == 'Student' && params[:student].present?
          student_params = params.require(:student).permit(:department_id, :major_id, :class_id, :training_program_id)
          student = Student.new(student_params)
          user.student = student
        end

        # Xử lý Teacher
        if user.role == 'Teacher' && params[:teacher].present?
          teacher_params = params.require(:teacher).permit(:department_id)
          teacher = Teacher.new(teacher_params)
          user.teacher = teacher
        end

        if user.save
          # Tạo mã tự động cho Student hoặc Teacher
          if user.student
            user.student.update(student_code: "STU#{format('%06d', user.student.id)}")
          elsif user.teacher
            user.teacher.update(teacher_code: "TCH#{format('%06d', user.teacher.id)}")
            # Gán môn học (chuyên môn) cho giáo viên thông qua subject_assignments
            if params[:teacher].present? && params[:teacher][:subject_id].present?
              SubjectAssignment.create!(
                school_id: @current_user.school_id,
                teacher_id: user.teacher.id,
                subject_id: params[:teacher][:subject_id]
              )
            end
          end
          render json: user.as_json(include: {
            student: { include: { class: { only: [:name] }, major: { only: [:name] }, training_program: { only: [:name] } }, only: [:student_code] },
            teacher: { include: { subjects: { only: [:name] } }, only: [:teacher_code] }
          }), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        user = User.where(school_id: @current_user.school_id).find(params[:id])
        if user.update(user_params)
          render json: user.as_json(include: {
            student: { include: { class: { only: [:name] }, major: { only: [:name] }, training_program: { only: [:name] } }, only: [:student_code] },
            teacher: { include: { subjects: { only: [:name] } }, only: [:teacher_code] }
          })
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.where(school_id: @current_user.school_id).find(params[:id])
        if @current_user.role == 'AdminSchools' && user.role == 'AdminSchools'
          render json: { error: 'Không thể xóa tài khoản AdminSchools' }, status: :forbidden
        else
          user.destroy
          head :no_content
        end
      end

      def create_admin_account
        school = School.find(params[:school_id])
        unless @current_user.role == 'SuperAdmin'
          render json: { error: 'Forbidden' }, status: :forbidden
          return
        end

        user = User.new(user_params.merge(school_id: school.id, role: 'AdminSchools'))
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:username, :password, :role)
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
        render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.role == 'AdminSchools' || @current_user.role == 'SuperAdmin'
      end
    end
  end
end

