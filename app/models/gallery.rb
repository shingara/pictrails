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

  # Create a Gallery with description empty
  # and status true
  def self.new_empty
    gallery = Gallery.new
    gallery.description = ''
    gallery.status = true
    gallery
  end

  # Create a Gallery with the name of a directory.
  # All directory in this directory are gallery too
  # but with parent like the first directory
  # if the directory is not a directory, return an empty
  # array if the directory is not a directory
  def self.create_from_directory(directory)
    gallery_import = Pictrails::ImportSystem.search(directory)
    unless gallery_import.nil?
      Gallery.create_by_import_gallery(gallery_import)
    else
      nil
    end
  end

  # Create the Gallery and all import for all picture in this
  # directory
  def self.create_by_import_gallery(gallery_import, parent = nil)
    gallery = Gallery.new_empty
    gallery.name = gallery_import.name
    gallery.parent = parent
    gallery.define_name(gallery_import.name)
    gallery.save!
    gallery.insert_pictures(gallery_import.path)
    gallery_import.child.each do |gallery_child|
      gallery.children << Gallery.create_by_import_gallery(gallery_child, gallery)
    end
    gallery.save
    gallery
  end

  # Change the name if it's already use in database
  def define_name(name)
    i = 1
    while not self.valid?
      self.name = name + "-#{i}"
      i += 1
    end
  end

  # Insert in this Gallery all picture in
  # the import table. The import model is use
  # only for the save of all file there are in this directory
  # All file are integrate in this gallery time after time
  # If the directory finish by / it's delete
  def insert_pictures(directory)
    list_import = []
    Dir.chdir(directory) do
      Dir.glob("*.{gif,png,jpg,bmp}", File::FNM_CASEFOLD) do |file|
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
