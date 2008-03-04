class SettingSweeper < ActionController::Caching::Sweeper
  observe Setting

  def after_create(setting)
    expire_cache(setting)
  end
  
  def after_update(setting)
    expire_cache(setting)
  end

private

  def expire_cache(setting)
    expire_page :controller => '/galleries', :action => 'index'
    expire_page '/'
    cache_dir = ActionController::Base.page_cache_directory
    FileUtils.rm_r(Dir.glob(cache_dir+"/galleries/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir+"/galleries")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir+"/pictures/page/*")) rescue Errno::ENOENT
  end
end
