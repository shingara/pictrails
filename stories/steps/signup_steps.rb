steps_for(:signup) do
  Given "a username '$username'" do |username|
    @username = username
  end

  Given "a password '$password'" do |password|
    @password = password
  end

  Given "an email '$email'" do |email|
    @email = email
  end

  When "the user creates an account with username, password and email" do
    post "/admin/users", :user => { :login => @username,
                                     :password => @password,
                                     :password_confirmation => @password,
                                     :email => @email }
  end

end
