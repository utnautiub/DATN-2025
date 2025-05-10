class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_standard_error(exception)
    logger.error "#{exception.class.name}: #{exception.message}"
    logger.error exception.backtrace.join("\n")

    error_message = "Lỗi máy chủ nội bộ"
    error_message = exception.message if Rails.env.development?

    render json: { error: error_message }, status: :internal_server_error
  end
end
