class ShortUrls::Service
  def initialize(user, params)
    @user = user
    @params = params
  end

  def find(id)
    @user.short_urls.find_by_id(id)
  end

  def get_short_urls
    limit = @params['limit'].to_i || 20
    offset = @params['offset'].to_i || 0
    @user.short_urls.limit(limit).offset(offset)
  end

  def update(short_url, data)
    # Update one instance short url
    short_url.update!(data)
    ServiceResponse.success(payload: short_url)
  rescue ActiveRecord::RecordNotUnique
    ServiceResponse.error(message: 'Shorten has been used!')
  end

  def delete(short_url_id)
    ShortUrl.destroy(short_url_id)
  end

  def extract_title(url)
    require 'nokogiri'
    require 'open-uri'

    URI.open(url) do |f|
      doc = Nokogiri::HTML(f)
      title = doc.at_css('title').text
      title
    end
  end
end
