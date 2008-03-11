class AddPermalinkToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, 'permalink', :string
    add_index :galleries, 'permalink', :unique => true
    Gallery.find(:all).each do |gallery|
      gallery.define_permalink
      gallery.save
    end
  end

  def self.down
    remove_index :galleries, 'permalink'
    remove_column :galleries, 'permalink'
  end
end
