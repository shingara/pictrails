class AddPermalinkToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, 'permalink', :string
    add_index :pictures, 'permalink', :unique => true
    Picture.find(:all).each do |picture|
      picture.define_permalink
      picture.save
    end
  end

  def self.down
    remove_index :pictures, 'permalink'
    remove_column :pictures, 'permalink'
  end
end
