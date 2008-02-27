class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name
      t.text :description
      t.boolean :status
      t.date :created_at
      t.date :updated_at

      t.timestamps
    end

    add_index :galleries, :name, :unique => true
    add_index :galleries, :status
  end

  def self.down
    drop_table :galleries
  end
end
