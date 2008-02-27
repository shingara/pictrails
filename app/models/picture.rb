class Picture < ActiveRecord::Base

  belongs_to :gallery
  has_many :thumbnails, :foreign_key => 'parent_id'
  
  has_attachment :content_type => :image, 
      :storage => :file_system, 
      :max_size => 1.megabytes,
      :resize_to => '600x450>',
      :thumbnail_class => Thumbnail, 
      :thumbnails => { :thumb => '200x200>' }
  
  validates_as_attachment


  validates_presence_of :filename, :message => 'is needed for your picture'
  validates_presence_of :gallery_id, :message => 'is needed for you picture' 
  validates_associated :gallery, :messsage => 'is needed for you picture'
  validates_presence_of :size, :message => 'is needed for you picture'
  validates_presence_of :title, :message => 'is needed for you picture'

end
