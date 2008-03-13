require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PicturesController do
  controller_name 'admin/pictures'
  fixtures :galleries, :pictures, :thumbnails, :users
  include AuthenticatedTestHelper

  before (:each) do
    login_as :quentin
  end

  it 'should see all pictures' do
    get :index
    response.should be_success
    response.should render_template('index')
  end

  it 'should see show picture' do
    get :show, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink
    response.should be_success
    response.should render_template('show')
  end

  it 'should return 404 if no picture in show' do
    get :show, :id => 'unknow_picture', :gallery_id => galleries(:gallery1).permalink
    response.response_code.should == 404
  end
  
  it 'should see edit picture' do
    get :edit, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink
    response.should be_success
    response.should render_template('edit')
  end

  it 'should return 404 if no picture in edit' do
    get :edit, :id => 'unknow_picutre', :gallery_id => galleries(:gallery1).permalink
    response.response_code.should == 404
  end

  it 'should see new page of picture in admin' do
    get :new, :gallery_id => galleries(:gallery1)
    response.should be_success
    response.should render_template('new')
  end

  it 'should update picture in admin for a gallery' do
    p = Picture.find 1
    p.title.should_not == 'oui'
    get :update, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink, :picture => {:title => 'oui'}
    response.should redirect_to(admin_gallery_picture_url(galleries(:gallery1),pictures(:picture1)))
    p = Picture.find 1
    p.title.should == 'oui'
  end

  it 'should not update picture in admin for a gallery because no title' do
    p = Picture.find 1
    p.title.should_not == ''
    put :update, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink, :picture => {:title => ''}
    response.should be_success
    response.should render_template('edit')
    p = Picture.find 1
    p.title.should_not == ''
  end

  it 'should create a picture in admin for a gallery' do
    Picture.count.should == 3
    post 'create', :gallery_id => galleries(:gallery1).permalink, :picture => {:gallery_id => 1, 
      :title => 'oui', 
      :description => 'good description', 
      :status => true, 
      :uploaded_data => fixture_file_upload("/files/rails.png", 'image/png', :binary)}

    response.should redirect_to(admin_gallery_picture_url(galleries(:gallery1), 'oui'))
    Picture.count.should == 4
  end

  it 'should not create a picture in admin for a gallery because no title' do
    Picture.count.should == 3
    post 'create', :gallery_id => 1, :picture => {:gallery_id => 1, :title => '', :description => 'good description', :status => true, :uploaded_data => fixture_file_upload("/files/rails.png", 'image/png', :binary)}
    response.should be_success
    response.should render_template("new")
    Picture.count.should == 3
  end
  
  it 'should not create a picture in admin for a gallery because no file' do
    Picture.count.should == 3
    post 'create', :gallery_id => 1, :picture => {:gallery_id => 1, :title => '', :description => 'good description', :status => true}
    response.should be_success
    response.should render_template("new")
    Picture.count.should == 3
  end

  it 'should be destroy a picture' do
    Picture.count.should == 3
    Picture.find(1).should_not be_nil
    delete 'destroy', :gallery_id => galleries(:gallery1).permalink, :id => pictures(:picture1).permalink
    Picture.count.should == 2
    assert_raise ActiveRecord::RecordNotFound do
      Picture.find 1
    end
  end

  #Delete this example and add some real ones
  it "should use Admin::PicturesController" do
    controller.should be_an_instance_of(Admin::PicturesController)
  end

end
