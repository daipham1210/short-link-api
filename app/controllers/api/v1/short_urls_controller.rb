# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApiController
      def index
        short_urls = service.get_short_urls
        render json: {
          short_urls: ActiveModelSerializers::SerializableResource.new(
            short_urls
          ).as_json
        }
      end

      def create
        contract = ShortUrlContract.new.call(permit_params, context: { is_create: true })
        render_invalid_params(contract) and return unless contract.errors.empty?

        render_response(ShortUrls::Creator.call(current_user, permit_params))
      end

      def update
        short_url = service.find(params[:id])
        unless short_url
          render json: { errors: 'Short url not found' }, status: :bad_request
        end
        contract = ShortUrlContract.new.call(permit_params)
        render_invalid_params(contract) and return unless contract.errors.empty?

        render_response(service.save_short_url(short_url, permit_params))
      end

      private

      def service
        @short_url_service ||= ShortUrls::Service.new(current_user, params)
        @short_url_service
      end

      def permit_params
        params.permit(%i[origin shorten label]).to_h
      end

      def render_invalid_params(contract)
        render json: { errors: contract.errors.to_h }, status: :bad_request
      end
    end
  end
end
