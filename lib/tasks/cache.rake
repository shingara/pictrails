namespace :pictrails do
  desc 'Delete all cache of pictrail'
  task :delete_cache => [:environment] do
    PageCache.sweep_all
  end
end
