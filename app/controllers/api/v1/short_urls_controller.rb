# frozen_string_literal: true

module Api
  module V1
    class ShortUrlsController < ApiController
      before_action :validate_custom_shorten, only: :create

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
