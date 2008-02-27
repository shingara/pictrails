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
    #expire_page :controller => '/pictures', :action => :show
    expire_page :controller => '/galleries', :action => :show, :id => picture.gallery.id
    expire_page :controller => '/galleries', :action => 'index'
    expire_page '/'
  end
end
