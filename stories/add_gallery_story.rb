require File.dirname(__FILE__) + "/helper"

with_steps_for(:general, :signup, :gallery) do
  run_local_story "add_gallery_story", :type => RailsStory
end
