module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    token = request.headers["Authorization"]&.split(" ")&.last
    begin
      decoded = JWT.decode(token, "your_secret_key", true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def require_admin_schools
    render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "AdminSchools" || @current_user.role == "SuperAdmin"
  end

  def require_super_admin
    render json: { error: "Forbidden" }, status: :forbidden unless @current_user.role == "SuperAdmin"
  end

  def current_school_scope
    if @current_user.role == "SuperAdmin"
      model_class.all
    else
      model_class.where(school_id: @current_user.school_id)
    end
  end
end
