require File.join(File.dirname(__FILE__), "helper")

Story "Create first user",
%(There are no user and it's first start of pictrails), :type => RailsStory do
 
  Scenario "Add a gallery" do

    Given "complete gallery" do
    end

    When "go admin" do
      post "/"
    end
    Then "response be success" do
      response.should redirect_to('/admin/signup')
      follow_redirect!
      response.should render_template('admin/users/new')
    end
  end
end 

