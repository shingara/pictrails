module Spec
  class << self; def run; false; end; end
end

namespace :spec do 


  desc "run all rspec stories"  
  task :stories do
    require 'stories/all.rb'
  end
end
