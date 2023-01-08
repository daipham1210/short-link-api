class ShortUrl < ApplicationRecord
  CUSTOM_SHORTEN_LENGTH = 128
  # Validation
  validates :origin, presence: true, http_url: true
  validates :label, presence: true

  def short
    Rails.application.routes.url_helpers.short_url(shorten:)
  end
end
