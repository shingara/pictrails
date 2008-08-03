class PictureSweeper < ActionController::Caching::Sweeper
  
  include PageCache 
  
  observe Picture

  def after_create(picture)
    expire_cache(picture)
  end
  
  def after_update(picture)
    expire_cache(picture)
  end

  def after_destroy(picture)
    expire_cache(picture)
  end

private

  def expire_cache(picture)
    PageCache.sweep_all
  end

end
