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
    expire_page :controller => '/pictures', :action => :index
    expire_page :controller => '/galleries', :action => :show, :id => picture.gallery.id
    expire_page :controller => '/galleries', :action => 'index'
    expire_page '/'
    cache_dir = ActionController::Base.page_cache_directory
    FileUtils.rm_r(Dir.glob(cache_dir+"/galleries/page/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir+"/pictures/page/*")) rescue Errno::ENOENT
  end
end
