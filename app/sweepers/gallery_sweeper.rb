class GallerySweeper < ActionController::Caching::Sweeper
  observe Gallery

  def after_create(gallery)
    expire_cache(gallery)
  end
  
  def after_update(gallery)
    expire_cache(gallery)
  end

  def after_destroy(gallery)
    expire_cache(gallery)
  end


private

  def expire_cache(gallery)
    expire_page :controller => '/galleries', :action => :show, :id => gallery
    expire_page :controller => '/galleries', :action => 'index'

    delete_cache_pagination_galleries(gallery)

    expire_page '/'
  end
  
  # Delete the cache about pagination in galleries view
  def delete_cache_pagination_galleries(gallery)
    FileUtils.rm_r(Dir.glob(@cache_dir+"/galleries/page/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(@cache_dir+"/galleries/#{gallery.permalink}/page/*")) rescue Errno::ENOENT
  end
end
