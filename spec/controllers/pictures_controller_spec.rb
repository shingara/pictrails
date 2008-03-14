require File.dirname(__FILE__) + '/../spec_helper'

describe PicturesController do
  controller_name :pictures

  before :each do
    @picture = mock_model(Picture)
    @gallery = mock_model(Gallery)
  end

  it 'should see a picture' do
    @picture.should_receive(:permalink).and_return('my_permalink')
    Picture.should_receive(:find_by_permalink).with(@picture.permalink).and_return(@picture)

    get 'show', :gallery_id =>'my_permalink_gallery', :id => 'my_permalink'

    response.should be_success
    response.should render_template('show')
  end

  it 'should not see picture and return a 400' do
    @picture.should_receive(:permalink).and_return('my_permalink')
    Picture.should_receive(:find_by_permalink).with(@picture.permalink).and_return(nil)

    get 'show', :gallery_id => 'my_permalink_gallery', :id => 'my_permalink'

    response.response_code.should == 404
    response.should render_template("#{RAILS_ROOT}/public/404.html")
  end
end
