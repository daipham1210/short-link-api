# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApiController
      before_action :find_short_url, only: [:update, :destroy]
      def index
        short_urls = service.get_short_urls
        render json: {
          short_urls: ActiveModelSerializers::SerializableResource.new(
            short_urls
          ).as_json
        }
      end

      def create
        validate_request_payload!(ShortUrlContract, permit_params)
        render_response(ShortUrls::Creator.call(current_user, permit_params))
      end

      def update
        validate_request_payload!(ShortUrlContract, permit_params)
        render_response(service.update(@short_url, permit_params))
      end

      def destroy
        service.delete(@short_url.id)
        render json: { success: true }, status: :ok
      end

      def check_shorten_available
        is_available = service.check_shorten_available(params[:shorten])
        render json: { is_available: }, status: :ok
      end

      private

      def service
        ShortUrls::Service.new(current_user, params)
      end

      def permit_params
        params.permit(%i[origin shorten label]).to_h
      end

      def find_short_url
        @short_url = service.find(params[:id])
        not_found!('Short url not found!') unless @short_url
      end
    end
  end
end
