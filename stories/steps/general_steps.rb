steps_for(:general) do
  
  Given "a username '$username'" do |username|
    @username = username
  end

  Given "a password '$password'" do |password|
    @password = password
  end

  Given "an email '$email'" do |email|
    @email = email
  end

  Given 'the user is save' do
    User.create(:login => @username,
            :password => @password,
            :password_confirmation => @password,
            :email => @email).save!
  end
  
  Given "load all fixtures" do
    ["galleries", "pictures", "thumbnails", "users", "settings"].each { |fixture|
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, fixture)
    }
  end

  Given "there are no $model save" do |model|
    eval "#{model.camelize}.destroy_all"
  end

  Given "all cache delete" do
    PageCache.sweep_all
  end
  
  When "the user logged" do
    post "/admin/session", :login => @username, :password => @password
  end

  When "the user go to the base URL" do
    get '/'
  end

  When "go to '$path'" do |path|
    get path
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

  Then 'the response is a success' do
    response.should be_success
  end

  Then "the '$path' is cached" do |path|
    File.file?(ActionController::Base.page_cache_directory + "/#{path}").should == true
  end
  
  Then "no '$path' is cached" do |path|
    File.file?(ActionController::Base.page_cache_directory + "/#{path}").should == false
  end
end
