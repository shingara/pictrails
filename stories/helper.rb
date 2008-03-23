ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'

def run_local_story(filename, options={})
  run File.join(File.dirname(__FILE__), filename), options
end
