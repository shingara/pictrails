class GallerySweeper < ActionController::Caching::Sweeper

  include PageCache 

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
    @cache_dir = ActionController::Base.page_cache_directory
    expire_cache_galleries(gallery)
    delete_cache_pagination_galleries(gallery)
    expire_root
  end
end
