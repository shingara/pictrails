class Gallery < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy do
    def enable_size
      count :conditions => "status = 't'"
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

  # Static method
  # create a Gallery and several picture in this gallery
  # All pictures are in directory define in params
  def self.create_with_directory(directory)
    gallery = Gallery.new 
    raise ArgumentError.new('the directory need a directory') unless File.directory? directory
    gallery.name = File.basename directory
    gallery.description = ''
    gallery.status = true
    gallery.save!

    Dir.chdir(directory) do
      Dir.glob("*.{gif,png,jpg,bmp}") do |file|
        pic = Picture.new
        pic.title = file[0, file.rindex('.')]
        pic.description = ''
        pic.status = true
        pic.content_type = File.mime_type? file
        pic.filename = file
        pic.temp_data = File.new(file).read
        pic.gallery_id = gallery.id
        pic.save!
      end
    end
  end
end
