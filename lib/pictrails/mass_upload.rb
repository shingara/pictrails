# nodoc #
module Pictrails

  # Module to manage the mass_upload
  module MassUpload

    # Check if an import exist still in database
    # If an import exist, it's factory
    # Use RAILS_DEFAULT_LOGGER because we can be out of Rails class
    def upload_file
      RAILS_DEFAULT_LOGGER.debug 'upload file launch'
      imports = Import.find :all, :include => 'gallery', 
        :limit => Setting.default.nb_upload_mass_by_request,
        :conditions => [ 'gallery_id IS NOT NULL']
      imports.each { |import|
        RAILS_DEFAULT_LOGGER.debug 'one pictures import'
        begin
          Picture.create_picture_by_import(import)
        rescue Errno::ENOENT
          RAILS_DEFAULT_LOGGER.warn 'A file in Import directory is bad. Send a bug report'
          import.destroy
        end
        PageCache.sweep_all
        import.destroy
      }
      @imports = Import.gallery_import.all.group_by(&:gallery)
    end
  end
end
