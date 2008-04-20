class Gallery < ActiveRecord::Base
  has_many :imports
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

  # Insert in this Gallery all picture in
  # the import table. The import model is use
  # only for the save of all file there are in this directory
  # All file are integrate in this gallery time after time
  def insert_pictures(directory)
    Dir.chdir(directory) do
      Dir.glob("*.{gif,png,jpg,bmp}") do |file|
        i = Import.new
        directory.chop! if directory[-1,1] == '/'
        i.path = "#{directory}/#{file}"
        i.gallery = self
        i.save!
      end
    end if File.directory? directory
  end
end
