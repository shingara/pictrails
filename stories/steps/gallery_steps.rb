steps_for(:gallery) do

  Given "in gallery '$name'" do |name|
    g = Gallery.find_by_name name
    @gallery = g.permalink
    @gallery_id = g.id
  end

  When "add create gallery '$name'" do |name|
    post '/admin/galleries', :gallery => {:name => name,
                                          :status => true,
                                          :description => ""}
  end
  When "add a picture '$path' with name '$name'" do |path, name|
    if @gallery
      multipart_post "/admin/galleries/#{@gallery}/pictures", 
                        :gallery_id => @gallery_id,
                        :picture => {
                          :gallery_id => @gallery_id,
                          :title => name,
                          :status => true,
                          :description => "",
                          :uploaded_data => fixture_file_upload("#{path}", 'image/png', :binary)}
    end
  end

  When "update '$gallery' to description with '$description'" do |gallery, description|
    put "/admin/galleries/#{gallery}", :gallery => {:description => description}
  end


  Then "there are one gallery with name '$name'" do |name|
    Gallery.should have(1).find(:all)
    g = Gallery.find_by_name name
    g.name.should == name
    g.status.should be_true
  end
end
