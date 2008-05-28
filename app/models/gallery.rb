class Gallery < ActiveRecord::Base
  has_many :imports
  has_many :pictures, :dependent => :destroy do
    def enable_size
      count :conditions => ["status = ?", true]
    end
  end

  acts_as_tree :order => :name

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
  # If the directory finish by / it's delete
  def insert_pictures(directory)
    list_import = []
    Dir.chdir(directory) do
      Dir.glob("*.{gif,png,jpg,bmp}") do |file|
        i = Import.new
        directory.chop! if directory[-1,1] == '/'
        i.path = "#{directory}/#{file}"
        i.gallery = self
        list_import << i
      end

      # Save the import with the total size for this import
      list_import.each { |i|
        i.total = list_import.size
        i.save!
      }
    end if File.directory? directory
  end

  # Retrieve all Gallery without the gallery
  # send by parameter
  def self.find_without(gallerie)
    find :all, :conditions => ['id <> ?', gallerie.id]
  end
end
