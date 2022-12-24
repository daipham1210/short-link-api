class Api::V1::ShortUrlsController < ApiController
  def create
    @short_url = ShortUrls::Creator.call(current_user, shorturl_params)
    if @short_url.persisted?
      render json: @short_url, status: :ok
    else
      render json: { errors: @short_url.errors.full_messages }, status: :bad_request
    end
  end

  private

  def shorturl_params
    params.permit(%i[origin shorten])
  end
end
