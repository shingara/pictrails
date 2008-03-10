class SettingSweeper < ActionController::Caching::Sweeper
  observe Setting

  def after_create(setting)
    PageCache.sweep_all
  end
  
  def after_update(setting)
    PageCache.sweep_all
  end
end
