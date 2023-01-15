module RenderHelper
  extend ActiveSupport::Concern

  def not_found!(messages)
    raise Error::CustomError.new(:not_found, 404, messages)
  end

  def bad_request!(messages)
    raise Error::CustomError.new(:bad_request, 400, messages)
  end

  def render_response(response, error_status = 400)
    if response.success?
      render json: response.payload, status: :ok
    else
      render json: { messages: [response.message] }, status: error_status
    end
  end
end
