dir = File.dirname(__FILE__)
require 'stories/integration_test_file_upload_deep'
require 'stories/helper'
Dir[File.expand_path("#{dir}/steps/*.rb")].uniq.each do |file|
    require file
end

with_steps_for(:general, :signup, :gallery) do
  run_local_story "add_gallery_story", :type => RailsStory
end

with_steps_for(:general, :signup, :gallery) do
  run_local_story "signup_story", :type => RailsStory
end

with_steps_for(:general, :admin, :gallery) do
  run_local_story "view_gallery_story", :type => RailsStory
end
