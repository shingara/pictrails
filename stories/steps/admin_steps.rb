steps_for(:admin) do

  Given "the user logged" do
    post "/admin/session", :login => 'quentin', :password => 'test'
  end
end
