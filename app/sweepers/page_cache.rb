class PageCache
  def self.sweep_all
    cache_dir = ActionController::Base.page_cache_directory
    # Delete index
    FileUtils.rm_r(cache_dir + '/index.html') rescue Errno::ENOENT

    # Delete Gallery and content
    FileUtils.rm_r(cache_dir + '/galleries.html') rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/galleries/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/galleries")) rescue Errno::ENOENT

    # Delete Pictures and content
    FileUtils.rm_r(cache_dir + '/pictures.html') rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/pictures/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/pictures/")) rescue Errno::ENOENT
  end
end
