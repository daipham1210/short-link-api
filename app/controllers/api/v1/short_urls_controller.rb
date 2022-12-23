class Api::V1::ShortUrlsController < ApiController
  def create
    @short_url = ShortUrls::Creator.call(current_user, params[:origin])
    if @short_url.save
      render json: @short_url, status: :ok
    else
      render json: { data: @short_url.errors.full_messages, status: "failed" }, status: :unprocessable_entity
    end
  end
end
