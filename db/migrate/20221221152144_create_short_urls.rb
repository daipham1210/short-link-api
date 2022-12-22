class CreateShortUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :short_urls do |t|
      t.string :origin, null: false, default: "", limit: 1024
      t.string :shorten, null: false, default: "", limit: 160
      t.datetime :expire_at
      t.integer  :hits, default: 0, null: false
      t.references :user

      t.timestamps
    end
    add_index :short_urls, :shorten, unique: true
  end
end
