class ShortUrl < ApplicationRecord
  self.primary_key = :shorten
  SHORTEN_LENGTH = 6

  # Callback
  before_create :generate_shorten

  def generate_shorten
    self.shorten = SecureRandom.alphanumeric(SHORTEN_LENGTH)
  end
end
