class ShortUrl < ApplicationRecord
  # Validation
  validates :origin, presence: true, http_url: true

  def short
    Rails.application.routes.url_helpers.short_url(shorten:)
  end
end
