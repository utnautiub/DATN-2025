# app/controllers/api/v1/subjects_controller.rb
module Api
  module V1
    class SubjectsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools

      def index
        subjects = Subject.all
        render json: subjects
      end

      def create
        subject = Subject.new(subject_params)
        if subject.save
          render json: subject, status: :created
        else
          render json: { errors: subject.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        subject = Subject.find(params[:id])
        if subject.update(subject_params)
          render json: subject
        else
          render json: { errors: subject.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        subject = Subject.find(params[:id])
        subject.destroy
        head :no_content
      end

      private

      def subject_params
        params.permit(:name, :code, :description)
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