module Api
  class BaseController < ApplicationController
    include Authenticable
    include Responder
    include AuthorizationChecker

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

    def authorize_resource(resource_id, resource_type, action)
      unless authorized_for_resource?(resource_type, resource_id, action)
        respond_with_errors("Bạn không có quyền thực hiện hành động này", :forbidden)
        return false
      end
      true
    end
  end
end
