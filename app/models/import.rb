class Import < ActiveRecord::Base

  THUMB = 1
  VIEW = 2

  belongs_to :gallery
  belongs_to :picture

  named_scope :limited, lambda { |num| { :limit => num } }
  named_scope :gallery_import, :conditions => ['gallery_id IS NOT NULL']
  named_scope :picture_update, :conditions => ['picture_id IS NOT NULL']


  def update_size
    if type_pic == THUMB
      Picture.find(picture_id).update_thumb
      destroy
    end
    if type_pic == VIEW
      Picture.find(picture_id).update_view
      destroy
    end
  end

end
