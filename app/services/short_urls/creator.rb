# frozen_string_literal: true

module ShortUrls
  class Creator
    include Callable
    SHORTEN_LENGTH = 6

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      loop do
        return save_short_url
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end

    private

    def generate_shorten
      SecureRandom.alphanumeric(SHORTEN_LENGTH)
    end

    def save_short_url
      short_url = ShortUrl.new(origin: @params[:origin])
      short_url.user_id = @user.id
      short_url.label = @params[:label]
      short_url.shorten = if @params[:shorten].to_s.empty?
                            generate_shorten
                          else
                            @params[:shorten].to_s
                          end
      short_url.expire_at = 1.month.from_now
      short_url.save
      short_url
    end
  end
end
