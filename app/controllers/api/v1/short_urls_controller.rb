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
        validate_payload(ShortUrlContract, permit_params, { is_create: true })
        render_response(ShortUrls::Creator.call(current_user, permit_params))
      end

      def update
        validate_payload(ShortUrlContract, permit_params)
        render_response(service.update(@short_url, permit_params))
      end

      def destroy
        service.delete(@short_url.id)
        render json: { success: true }, status: :ok
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
        raise Error::RecordNotFound.new('Short url not found!') unless @short_url
      end
    end
  end
end
