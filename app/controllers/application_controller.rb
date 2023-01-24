class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include RenderHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  def validate_request_payload!(contract_class, payload, context = {})
    contract = contract_class.new.call(payload, context)
    contract_errors = contract.errors(full: true).to_h
    messages = contract_errors.values.flatten
    bad_request!(messages) unless contract.errors.empty?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
