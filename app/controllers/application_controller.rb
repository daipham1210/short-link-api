class ApplicationController < ActionController::API
  def render_response(response, error_status = :bad_request)
    if response.success?
      render json: response.payload, status: :ok
    else
      render json: { error: response.message }, status: error_status
    end
  end
end
