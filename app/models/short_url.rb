# == Schema Information
#
# Table name: short_urls
#
#  id         :bigint           not null, primary key
#  origin     :string(1024)     default(""), not null
#  shorten    :string(160)      default(""), not null
#  expire_at  :datetime
#  hits       :integer          default(0), not null
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  label      :string(255)
#
class ShortUrl < ApplicationRecord
  CUSTOM_SHORTEN_LENGTH = 128
  # Validation
  validates :origin, presence: true, http_url: true
  validates :label, presence: true

  def short
    Rails.application.routes.url_helpers.short_url(shorten:)
  end
end
