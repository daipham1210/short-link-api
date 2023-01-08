module ShortUrls
  class Service
    def initialize(user, params)
      @user = user
      @params = params
    end

    def find(id)
      @user.short_urls.find(id)
    end

    def get_short_urls
      limit = @params['limit'].to_i || 20
      offset = @params['offset'].to_i || 0
      @user.short_urls.limit(limit).offset(offset)
    end

    def save_short_url(short_url, permit_params)
      short_url.update!(permit_params)
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
end
