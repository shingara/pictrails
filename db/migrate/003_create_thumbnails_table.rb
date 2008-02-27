class CreateThumbnailsTable < ActiveRecord::Migration
  def self.up
    create_table :thumbnails do |t|
      t.string  :content_type
      t.string  :thumbnail
      t.string  :filename
      t.integer :parent_id
      t.integer :size
      t.integer :width
      t.integer :height
    end
  end

  def self.down
    drop_table :thumbnails
  end
end
