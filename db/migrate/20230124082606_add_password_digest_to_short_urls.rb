class AddPasswordDigestToShortUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :short_urls, :password_digest, :string
  end
end
