# frozen_string_literal: true

module ShortUrls
  class Creator
    include Callable

    def initialize(user, origin)
      @user = user
      @origin = origin
    end

    def call
      loop do
        return save_short_url
      rescue ActiveRecord::RecordNotUnique
        continue
      end
    end

    private

    def save_short_url
      short_url = ShortUrl.new(origin: @origin)
      short_url.user_id = @user.id
      short_url.expire_at = 1.month.from_now
      short_url.save
      short_url
    end
  end
end
