steps_for(:gallery) do

  Given "in gallery '$name'" do |name|
    g = Gallery.find_by_name name
    @gallery = g.permalink
  end

  When "add create gallery '$name'" do |name|
    post '/admin/galleries', :gallery => {:name => name,
                                          :status => true}
  end

  When "add a picture '$path'" do |path|
    if @gallery
      post "/admin/galleries/#{@gallery}/pictures", :picture => {
        :uploaded_data => fixture_file_upload("#{path}", 'image/png', :binary)}
    end
  end


  Then "there are one gallery with name '$name'" do |name|
    Gallery.should have(1).find(:all)
    g = Gallery.find(1)
    g.name.should == name
    g.status.should be_true
  end
end
