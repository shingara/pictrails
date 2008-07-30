class PictureSweeper < ActionController::Caching::Sweeper
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
    expire_cache_galleries(picture) 
    expire_cache_tags(picture)

    expire_page '/'

    @cache_dir = ActionController::Base.page_cache_directory

    delete_cache_pagination_pictures(picture)
    delete_cache_pagination_galleries
  end

  # Delete all cache on pictures view the index and all show
  def expire_cache_pictures(picture)
    expire_page :controller => '/pictures', :action => :index
    expire_page :controller => '/pictures', :action => :show, :id => picture
  end

  # Delete the cache about pagination in pictures view
  def delete_cache_pagination_pictures(picture)
    FileUtils.rm_r(Dir.glob(@cache_dir+"/pictures/page/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(@cache_dir+"/pictures/#{picture.permalink}.html")) rescue Errno::ENOENT
  end
  
  # Delete all cache on galleries view the index and all show
  def expire_cache_galleries(picture)
    expire_page :controller => '/galleries', :action => :index
    expire_page :controller => '/galleries', :action => :show, :id => picture.gallery
  end
  
  # Delete the cache about pagination in galleries view
  def delete_cache_pagination_galleries
    FileUtils.rm_r(Dir.glob(@cache_dir+"/galleries/page/*")) rescue Errno::ENOENT
  end

  # Delete all cache about old and new tag in this picture
  def expire_cache_tags(picture)
    picture.tags.each do |tag|
      expire_page :controller => '/tags', :action => :show, :id => tag
    end

    picture.old_tag.each do |tag|
      expire_page :controller => '/tags', :action => :show, :id => tag
    end
  end

end
