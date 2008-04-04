ENV["RAILS_ENV"] = "stories"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

def run_local_story(filename, options={})
  run File.join(File.dirname(__FILE__), filename), options
end
