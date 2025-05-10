# app/controllers/api/v1/school_classes_controller.rb
module Api
  module V1
    class SchoolClassesController < Api::BaseController
      before_action :require_admin_schools

      def index
        school_classes = SchoolClass.where(school_id: @current_user.school_id)
                                    .includes(homeroom_teacher: :teacher)
        respond_with_collection(school_classes, include: {
          homeroom_teacher: {
            include: { teacher: { only: [ :name ] } },
            only: [ :id, :username ]
          }
        })
      end

      def create
        validator = TeacherValidatorService.new(params, @current_user)
        if validator.valid_homeroom_teacher?
          school_class = SchoolClass.new(school_class_params.merge(school_id: @current_user.school_id))
          if school_class.save
            respond_with_resource(school_class, {}, :created)
          else
            respond_with_errors(school_class.errors.full_messages)
          end
        else
          respond_with_errors(validator.errors)
        end
      end

      def update
        validator = TeacherValidatorService.new(params, @current_user)
        if validator.valid_homeroom_teacher?
          school_class = SchoolClass.where(school_id: @current_user.school_id).find(params[:id])
          if school_class.update(school_class_params)
            respond_with_resource(school_class)
          else
            respond_with_errors(school_class.errors.full_messages)
          end
        else
          respond_with_errors(validator.errors)
        end
      end

      def destroy
        school_class = SchoolClass.where(school_id: @current_user.school_id).find(params[:id])
        school_class.destroy
        respond_with_no_content
      end

      private

      def school_class_params
        params.permit(:name, :homeroom_teacher_id).reject { |_, v| v.blank? }
      end

      def model_class
        SchoolClass
      end
    end
  end
end
