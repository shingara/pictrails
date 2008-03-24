steps_for(:signup) do

  When "the user creates an account with username, password and email" do
    post "/admin/users", :user => { :login => @username,
                                     :password => @password,
                                     :password_confirmation => @password,
                                     :email => @email }
  end

  When "a user not logged want go to /admin/signup" do
    reset!
    get "/admin/signup"
  end

  Then "user save in first" do
    u = User.find(1)
    u.login.should == @username
    u.email.should == @email
  end

  Then "there are only one user" do
    User.should have(1).find(:all)
  end

end
