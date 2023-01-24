# frozen_string_literal: true

module ShortUrls
  class Creator
    include Callable
    include RenderHelper

    SHORTEN_LENGTH = 6

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      loop do
        return save_short_url
      rescue ActiveRecord::RecordNotUnique
        if @params[:shorten].to_s.empty?
          next
        else
          bad_request!('Shorten has been used')
        end
      rescue StandardError => e
        Rails.logger.debug("CREATE_SHORT_URL: FAILED - user_id #{@user.id} - params - #{@params.inspect}} ")
        Rails.logger.debug(e.message)
        bad_request!('Failed to create short url')
      end
    end

    private

    def generate_shorten
      SecureRandom.alphanumeric(SHORTEN_LENGTH)
    end

    def save_short_url
      origin = @params[:origin].to_s || ''
      password = @params[:password].to_s || ''
      shorten = @params[:shorten].to_s || ''
      short_url = ShortUrl.new(origin:)
      short_url.user_id = @user.id
      short_url.label = @params[:label] || ''
      short_url.shorten = if shorten.empty?
                            generate_shorten
                          else
                            shorten
                          end
      short_url.password = password unless password.empty?
      short_url.expire_at = 1.month.from_now
      short_url.save!
      ServiceResponse.success(payload: short_url)
    end
  end
end
