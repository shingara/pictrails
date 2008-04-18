# nodoc #
module Pictrails

  # Module to manage the mass_upload
  module MassUpload

    # Check if an import exist still in database
    # If an import exist, it's factory
    def upload_file
      imports = Import.find :all, :include => 'gallery', :limit => 5
      imports.each { |import|
        Picture.create_picture_by_import(import)
        PageCache.sweep_all
        import.destroy
      }
    end
  end
end
