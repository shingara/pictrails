namespace :spec do 
  desc "run all rspec stories"  
  task :stories => ['db:test:prepare'] do
    require 'stories/all'
  end
end
