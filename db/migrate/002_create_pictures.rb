class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :gallery_id
      t.string :content_type
      t.string :filename
      t.integer :parent_id
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :position
      t.string :title
      t.text :description
      t.boolean :status
      t.date :created_at
      t.date :updated_at

      t.timestamps
    end

    add_index :pictures, :gallery_id
    add_index :pictures, :filename
  end

  def self.down
    drop_table :pictures
  end
end
