class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include RenderHelper

  def validate_request_payload!(contract_class, payload, context = {})
    contract = contract_class.new.call(payload, context)
    contract_errors = contract.errors(full: true).to_h
    messages = contract_errors.values.flatten
    bad_request!(messages) unless contract.errors.empty?
  end
end
