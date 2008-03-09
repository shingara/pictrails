class Thumbnail < ActiveRecord::Base

  belongs_to :picture, :foreign_key => 'parent_id'

  has_attachment  :storage => :file_system,
    :content_type => :image,
    :path_prefix => 'public/pictrails_thumbnails'
end
