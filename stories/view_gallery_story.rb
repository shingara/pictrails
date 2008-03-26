require File.dirname(__FILE__) + "/helper"
require File.dirname(__FILE__) + "/steps/general_steps"

with_steps_for(:general) do
  run_local_story "view_gallery_story", :type => RailsStory
end
