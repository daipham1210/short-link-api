class ApplicationController < ActionController::API
  include Error::ErrorHandler
  def render_response(response, error_status = :bad_request)
    if response.success?
      render json: response.payload, status: :ok
    else
      render json: { error: response.message }, status: error_status
    end
  end

  def validate_payload(contract_class, payload, context = {})
    contract = contract_class.new.call(payload, context:)
    contract_errors = contract.errors(full: true).to_h
    messages = contract_errors.values.flatten
    raise Error::InvalidPayload.new(messages) unless contract.errors.empty?
  end
end
