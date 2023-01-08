# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApiController
      before_action :validate_custom_shorten, only: :create

      def index
        short_urls = service.get_short_urls
        render json: {
          short_urls: ActiveModelSerializers::SerializableResource.new(
            short_urls
          ).as_json
        }
      end

      def create
        @short_url = ShortUrls::Creator.call(current_user, permit_params)
        if @short_url.persisted?
          render json: @short_url, status: :ok
        else
          render json: { errors: @short_url.errors.full_messages }, status: :bad_request
        end
      end

      def update
      #   short_url = service.find(params[:id])
      #   unless short_url
      #     render json: { errors: 'Short Url not found' }, status: :bad_request
      #   end
      #   service.save_short_url(short_url, permit_params)

      #   render json: short_url, status: :ok
      # rescue e
      #   render json: { errors: @short_url.errors.full_messages }, status: :bad_request
      end

      private

      def service
        @short_url_service ||= ShortUrls::Service.new(current_user, params)
        @short_url_service
      end

      def permit_params
        params.permit(%i[origin shorten label])
      end

      def validate_custom_shorten
        return unless params.key?('shorten')

        custom_shorten = params[:shorten].to_s
        if !custom_shorten || custom_shorten.length > ShortUrl::CUSTOM_SHORTEN_LENGTH
          render json: { errors: 'Invalid custom short url' }, status: :bad_request
        end

        if ShortUrl.exists?(shorten: custom_shorten)
          render json: { errors: 'Short url has been used.' }, status: :bad_request
        end
      end
    end
  end
end
