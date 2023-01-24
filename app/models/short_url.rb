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
  has_secure_password validations: false
  CUSTOM_SHORTEN_LENGTH = 128
  # Validation
  validates :origin, presence: true, http_url: true
  validates :label, presence: true

  def secured?
    password_digest && !password_digest.empty?
  end

  def expired?
    expire_at < Time.now
  end
end
