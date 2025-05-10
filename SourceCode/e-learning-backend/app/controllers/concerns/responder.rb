module Responder
  extend ActiveSupport::Concern

  def respond_with_collection(collection, options = {})
    render json: collection.as_json(options)
  end

  def respond_with_resource(resource, options = {}, status = :ok)
    if resource.errors.any?
      respond_with_errors(resource.errors.full_messages)
    else
      render json: resource.as_json(options), status: status
    end
  end

  def respond_with_errors(errors, status = :unprocessable_entity)
    render json: { errors: Array(errors) }, status: status
  end

  def respond_with_success(message = nil, status = :ok)
    response = {}
    response[:message] = message if message.present?
    render json: response, status: status
  end

  def respond_with_no_content
    head :no_content
  end
end
