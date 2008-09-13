class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title
      t.text :body
      t.string :email
      t.string :author
      t.string :ip
      t.boolean :published
      t.integer :picture_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
