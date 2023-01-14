class AddLabelToShortUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :short_urls, :label, :string, limit: 255
  end
end
