namespace :spec do 
  desc "run all rspec stories"  
  task :stories do
    require 'stories/all.rb'
  end
end
