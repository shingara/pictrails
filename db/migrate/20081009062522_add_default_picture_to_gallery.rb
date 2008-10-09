class AddDefaultPictureToGallery < ActiveRecord::Migration
  def self.up
    add_column :galleries, :picture_id, :integer
    Gallery.all.each do |gallery|
      gallery.picture = gallery.pictures.first
      gallery.save
    end
  end

  def self.down
    remove_column :galleries, :picture_id
  end
end
