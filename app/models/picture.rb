class Picture < ActiveRecord::Base

  belongs_to :gallery
  has_many :thumbnails, :foreign_key => 'parent_id'
  
  has_attachment :content_type => :image, 
      :storage => :file_system, 
      :max_size => 1.megabytes,
      :resize_to => "#{Setting.default.picture_max_width}x#{Setting.default.picture_max_height}>",
      :path_prefix => 'public/pictrails_pictures',
      :thumbnail_class => Thumbnail, 
      :thumbnails => { :thumb => "#{Setting.default.thumbnail_max_width}x#{Setting.default.thumbnail_max_height}>"}
  
  validates_as_attachment


  validates_presence_of :filename, :message => 'is needed for your picture'
  validates_presence_of :gallery_id, :message => 'is needed for you picture' 
  validates_presence_of :size, :message => 'is needed for you picture'
  validates_presence_of :title, :message => 'is needed for you picture'
  
  validates_associated :gallery, :messsage => 'is needed for you picture'
  
  before_create :define_permalink

  # Define the permalink. Test if this permalink is already use.
  # if it already use add a -#{index} after
  def define_permalink
    if permalink.blank?
      permalink_insert_base = title.downcase.gsub(/[^a-z0-9]+/i, '-')
      permalink_insert = permalink_insert_base
      i = 1
      while !Picture.find_by_permalink(permalink_insert).nil? do
        permalink_insert = "#{permalink_insert_base}-#{i}"
        i = i + 1
      end
      self.permalink = permalink_insert
    end
  end

  def to_param
    permalink
  end

end
