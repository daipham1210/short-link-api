# frozen_string_literal: true

module ShortUrls
  class Creator
    include Callable
    SHORTEN_LENGTH = 6
    CUSTOM_SHORTEN_LENGTH = 128

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      validate_custom_shorten! if @params.key?('shorten')
      loop do
        return save_short_url
      rescue ActiveRecord::RecordNotUnique
        continue
      end
    end

    private

    def generate_shorten
      SecureRandom.alphanumeric(SHORTEN_LENGTH)
    end

    def save_short_url
      short_url = ShortUrl.new(origin: @params[:origin])
      short_url.user_id = @user.id
      short_url.shorten = @params[:shorten].to_s || generate_shorten
      short_url.expire_at = 1.month.from_now
      short_url.save
      short_url
    end

    def validate_custom_shorten!
      custom_shorten = @params[:shorten].to_s
      raise 'Invalid Short Url' if !custom_shorten || custom_shorten.length > CUSTOM_SHORTEN_LENGTH

      raise 'Short Url has been used' if ShortUrl.exists?(shorten: custom_shorten)
    end
  end
end
