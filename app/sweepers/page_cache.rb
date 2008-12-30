module PageCache

  def self.sweep_all
    cache_dir = ActionController::Base.page_cache_directory
    # Delete index
    FileUtils.rm_r(cache_dir + '/index.html') rescue Errno::ENOENT
    FileUtils.rm_r(cache_dir + '/sitemap*') rescue Errno::ENOENT

    # Delete Gallery and content
    FileUtils.rm_r(cache_dir + '/galleries.html') rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/galleries/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/galleries")) rescue Errno::ENOENT

    # Delete Pictures and content
    FileUtils.rm_r(cache_dir + '/pictures.html') rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/pictures/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(cache_dir + "/pictures/")) rescue Errno::ENOENT
  end
  
  # Delete the cache about pagination in galleries view
  def delete_cache_pagination_galleries(gallery)
    FileUtils.rm_r(Dir.glob(@cache_dir+"/galleries/page/*")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob(@cache_dir+"/galleries/#{gallery.permalink}/page/*")) rescue Errno::ENOENT
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
  def expire_cache_galleries(gallery)
    expire_page :controller => '/galleries', :action => :index
    expire_page :controller => '/galleries', :action => :show, :id => gallery
  end
  
  # Delete all cache about old and new tag in this picture
  def expire_cache_tags(picture)
    picture.tags.each do |tag|
      expire_page :controller => '/tags', :action => :show, :id => tag
      delete_cache_pagination_tag(tag)
    end

    picture.old_tag.each do |tag|
      expire_page :controller => '/tags', :action => :show, :id => tag
      delete_cache_pagination_tag(tag)
    end
  end
  
  # Delete the cache about pagination in tags view
  def delete_cache_pagination_tag(tag)
    FileUtils.rm_r(Dir.glob(@cache_dir+"/tags/#{tag.permalink}/page/*")) rescue Errno::ENOENT
  end

  # expire /
  def expire_root
    expire_page '/'
  end

end
