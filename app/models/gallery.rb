class Gallery < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy do
    def enable_size
      count :conditions => ["status = ?", true]
    end
  end

  validates_presence_of :name, :message => 'is needed for your gallery'
  validates_uniqueness_of :name, :message => 'is already use. Change it'

  before_create :define_permalink
  
  # define the permalink with name in downcase
  def define_permalink
    self.permalink = name.downcase.gsub(/[^a-z0-9]+/i, '-') if permalink.blank?
  end

  # define the param for permalink
  def to_param
    permalink
  end

  def self.create_with_directory(directory)
    gallery = Gallery.new 
  end

  # Create a Gallery with only his name that is is
  # the basename of directory send by path
  def self.create_by_name_of_directory(directory)
    gallery = Gallery.new 
    gallery.name = File.basename directory
    gallery.description = ''
    gallery.status = true
    gallery
  end

  # Insert in this Gallery all picture
  # in directory send by params
  def insert_pictures(directory)
    Dir.chdir(directory) do
      Dir.glob("*.{gif,png,jpg,bmp}") do |file|
        pic = Picture.new
        pic.title = file[0, file.rindex('.')]
        pic.description = ''
        pic.status = true
        pic.content_type = File.mime_type? file
        pic.filename = file
        pic.temp_data = File.new(file).read
        pic.gallery_id = self.id
        pic.save!
      end
    end if File.directory? directory
  end
end
