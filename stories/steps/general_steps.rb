steps_for(:general) do
  When "the user go to the base URL" do
    get '/'
  end
  
  Then "should redirect to '$path'" do |path|
    response.should redirect_to(path)
  end

  Then "follow redirect" do
    follow_redirect!
  end

  Then "render template '$path'" do |path|
    response.should render_template(path)
  end
end
