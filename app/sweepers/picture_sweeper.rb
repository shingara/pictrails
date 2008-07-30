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
    expire_cache_pictures(picture)
    expire_cache_galleries(picture.gallery) 
    expire_cache_tags(picture)

    expire_page '/'

    @cache_dir = ActionController::Base.page_cache_directory

    delete_cache_pagination_pictures(picture)
    delete_cache_pagination_galleries(picture.gallery)
  end

end
