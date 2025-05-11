# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < Api::BaseController
      skip_before_action :authenticate_user, only: [ :create ]

      def create
        # Bước 1: Kiểm tra username, trả về danh sách trường nếu trùng
        unless params[:school_id]
          unless params[:username]
            respond_with_errors("Username is required")
            return
          end

          # Tìm tất cả tài khoản với username này
          users = User.where(username: params[:username])

          if users.empty?
            respond_with_errors("Invalid username", :unauthorized)
            return
          end

          # Nếu chỉ có 1 tài khoản với username này, kiểm tra password và đăng nhập
          if users.length == 1
            user = users.first
            if user.authenticate(params[:password])
              token = encode_token({ user_id: user.id, role: user.role, school_id: user.school_id })
              render json: { user: user.as_json(except: [ :password_digest ]), token: token }, status: :ok
            else
              respond_with_errors("Invalid password", :unauthorized)
            end
            return
          end

          # Nếu có nhiều tài khoản với username này, trả về danh sách trường
          schools = users.map { |user| user.school }.compact
          render json: { schools: schools.as_json(only: [ :id, :name ]), requires_school_selection: true }, status: :ok
          return
        end

        # Bước 2: Đăng nhập với school_id
        unless params[:username] && params[:password] && params[:school_id]
          respond_with_errors("Username, password, and school_id are required")
          return
        end

        user = User.find_by(username: params[:username], school_id: params[:school_id])
        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id, role: user.role, school_id: user.school_id })
          render json: { user: user.as_json(except: [ :password_digest ]), token: token }, status: :ok
        else
          respond_with_errors("Invalid username, password, or school", :unauthorized)
        end
      end

      private

      def encode_token(payload)
        JWT.encode(payload, "your_secret_key")
      end
    end
  end
end
