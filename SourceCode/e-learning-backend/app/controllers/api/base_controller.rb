module Api
  class BaseController < ApplicationController
    include Authenticable
    include Responder

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    protected

    def model_class
      @model_class ||= controller_name.classify.constantize
    end

    def record_not_found(exception)
      respond_with_errors("Không tìm thấy: #{exception.message}", :not_found)
    end

    def record_invalid(exception)
      respond_with_errors(exception.record.errors.full_messages)
    end
  end
end
