# nodoc #
module Pictrails

  # Module to manage the import by mass_upload
  module ImportSystem
    
    # Manage a GalleryImport for the mass_upload
    class GalleryImport
      attr_reader :name, :path, :parent
      attr_accessor :child

      def initialize(path, name, parent)
        @path = path
        @name = name
        @parent = parent
        @child = []
      end

    end

    #Search all in directory and manage a tree of GalleryImport
    #and PictureImport
    def self.search(path, parent=nil)
      gallery_import = GalleryImport.new(path, File.basename(path), parent)
      Dir.chdir(path)
      Dir.glob('*') do |file|
        if File.directory?("#{path}/#{file}")
          gallery_import.child << self.search("#{path}/#{file}", gallery_import)
        end
      end
      gallery_import
    end

  end

end
