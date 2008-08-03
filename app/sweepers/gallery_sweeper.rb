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
    PageCache.sweep_all
  end
end
