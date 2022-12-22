class ShortUrl::Creator
  include Callable
  SHORTEN_LENGTH = 6

  def initialize(user, short_url_params)
    @user = user
    @short_url_params = short_url_params
  end

  def call
    while True
      short_url = save_short_url
    rescue =>
    end
    end
  end

  private

  def generate_shorten
    SecureRandom.alphanumeric(SHORTEN_LENGTH)
  end

  def save_short_url
    short_url = ShortUrl.new(@article_params)
    short_url.shorten = generate_shorten
    short_url.user_id = @user.id
    short_url.expire_at = 1.month.from_now
    short_url.save
    short_url
  end

  
end