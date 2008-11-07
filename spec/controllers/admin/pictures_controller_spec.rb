require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PicturesController , 'with no import' do
  controller_name 'admin/pictures'
  fixtures :galleries, :pictures, :thumbnails, :users
  include AuthenticatedTestHelper
  integrate_views

  before (:each) do
    Import.delete_all
    login_as :quentin
    @picture = mock_model(Picture)
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
    lambda {
      get :show, :id => 'unknow_picture', :gallery_id => galleries(:gallery1).permalink
    }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it 'should see edit picture' do
    get :edit, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink
    response.should be_success
    response.should render_template('edit')
  end

  it 'should return 404 if no picture in edit' do
    lambda {
      get :edit, :id => 'unknow_picutre', :gallery_id => galleries(:gallery1).permalink
    }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should see new page of picture in admin' do
    get :new, :gallery_id => galleries(:gallery1).permalink
    response.should be_success
    response.should render_template('new')
  end

  it 'should update picture in admin for a gallery' do
    p = Picture.find 1
    p.title.should_not == 'oui'
    get :update, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink, :picture => {:title => 'oui'}
    response.should redirect_to(admin_gallery_picture_url(galleries(:gallery1),'oui'))
    p = Picture.find 1
    p.title.should == 'oui'
  end

  it 'should not update picture in admin for a gallery because no title' do
    p = Picture.find 1
    p.title.should_not == ''
    put :update, :id => pictures(:picture1).permalink, :gallery_id => galleries(:gallery1).permalink, :picture => {:title => ''}
    response.should be_success
    response.should render_template('edit')
    assigns(:picture).title.should == ''
    p = Picture.find 1
    p.title.should_not == ''
  end

  it 'should create a picture in admin for a gallery' do
    assert_difference 'Picture.count' do
      post 'create', :gallery_id => galleries(:gallery1).permalink, :picture => {:gallery_id => 1, 
        :title => 'oui', 
        :description => 'good description', 
        :status => true, 
        :uploaded_data => fixture_file_upload("/files/rails.png", 'image/png', :binary)}

      response.should redirect_to(admin_gallery_picture_url(galleries(:gallery1), 'oui'))
    end
  end

  it 'should not create a picture in admin for a gallery because no title' do
    assert_no_difference 'Picture.count' do
      post 'create', :gallery_id => 1, :picture => {:gallery_id => 1, :title => '', :description => 'good description', :status => true, :uploaded_data => fixture_file_upload("/files/rails.png", 'image/png', :binary)}
      response.should be_success
      response.should render_template("new")
    end
  end
  
  it 'should not create a picture in admin for a gallery because no file' do
    assert_no_difference 'Picture.count' do
      post 'create', :gallery_id => 1, :picture => {:gallery_id => 1, :title => '', :description => 'good description', :status => true}
      response.should be_success
      response.should render_template("new")
    end
  end

  it 'should be destroy a picture' do
    assert_difference 'Picture.count', -1 do
      Picture.find(1).should_not be_nil
      delete 'destroy', :gallery_id => galleries(:gallery1).permalink, :id => pictures(:picture1).permalink
    end
    assert_raise ActiveRecord::RecordNotFound do
      Picture.find 1
    end
  end

  #Delete this example and add some real ones
  it "should use Admin::PicturesController" do
    controller.should be_an_instance_of(Admin::PicturesController)
  end

  describe 'copy action' do

    it 'should view copy form if get request' do
      get :copy, :picture_id => pictures(:picture1).permalink, :gallery_id => pictures(:picture1).gallery.permalink
      response.should be_success
      response.should render_template('copy')
    end

    it 'should copy picture to other gallery if post request' do
      assert_difference 'Import.count' do
        post :copy, :gallery_id => pictures(:picture1).permalink, :picture_id => pictures(:picture1).permalink, :picture => {:to_gallery_id => galleries(:gallery2).id}
        response.should redirect_to(admin_gallery_url(galleries(:gallery2)))
      end
    end

  end

end
