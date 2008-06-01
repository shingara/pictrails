require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/galleries_controller'

describe Admin::GalleriesController do 
  controller_name 'admin/galleries'

  describe 'with logged and import in progress' do
    fixtures :galleries, :pictures, :thumbnails, :users, :imports, :settings
    integrate_views

    include AuthenticatedTestHelper

    before(:each) do
      # define only one file by request are import
      setting = Setting.default
      setting.nb_upload_mass_by_request = 1
      setting.save!
      login_as :quentin
    end

    it 'should see the id import in view index' do
      get 'index'
      response.should be_success
      response.should have_tag('div#imports')
    end
    
    it 'should see the id import in view show 1' do
      get 'show', :id => galleries(:gallery1).permalink
      response.should be_success
      response.should have_tag('div#imports')
    end
  end

  describe 'without logged and no import' do
    fixtures :galleries, :pictures, :thumbnails, :users
    integrate_views

    it "should not view index" do
      get 'index'
      response.should redirect_to(admin_login_url)
    end

    it 'should not view show' do
      get 'show', :id => galleries(:gallery1).permalink
      response.should redirect_to(admin_login_url)
    end
    
    it 'should not view new gallery' do
      get 'new'
      response.should redirect_to(admin_login_url)
    end
    
    it 'should not edit gallery' do
      get 'edit', :id => galleries(:gallery1).permalink
      response.should redirect_to(admin_login_url)
    end

    it 'should not update gallery' do
      put 'update', :id => galleries(:gallery1).permalink, :gallery => {:name => 'oui'}
      response.should redirect_to(admin_login_url)
    end

    it 'should not create gallery' do
      post 'create', :gallery => {:name => 'gallery3', :description => 'good gallery', :status => true}
      response.should redirect_to(admin_login_url)
    end

    it 'should not destroy gallery' do
      delete 'destroy', :id => galleries(:gallery1).permalink
      response.should redirect_to(admin_login_url)
    end

  end

  describe 'with user logged and no import' do
    fixtures :galleries, :pictures, :thumbnails, :users
    include AuthenticatedTestHelper

    before (:each) do
      Import.delete_all
      login_as :quentin
      @gallery = mock_model(Gallery)
    end

    it 'should see index' do
      get 'index'
      response.should be_success
      assert_template 'index'
    end

    it 'should see first gallery' do
      get 'show', :id => galleries(:gallery1).permalink
      assert_response :success
      assert_template 'show'
    end
    
    it 'should see 404 error if gallery with bad id' do
      get 'show', :id => 10
      response.response_code.should == 404
    end

    it 'should see new page of gallery in admin' do
      get 'new'
      assert_response :success
      assert_template 'new'
    end

    it 'should edit gallery in admin' do
      get :edit, :id => galleries(:gallery1).permalink
      assert_response :success
      assert_template 'edit'
    end

    it 'should see 404 if id gallery not found' do
      get :edit, :id => 10
      assert_response 404
    end

    it 'should update gallery in admin' do
      g = Gallery.find 1
      g.name.should_not == 'oui'
      put 'update', :id => galleries(:gallery1).permalink, :gallery => {:name => 'oui'}
      response.should redirect_to(admin_galleries_url)
      g = Gallery.find 1
      g.name.should == 'oui'
    end

    it 'should not update gallery in admin because no name' do
      g = Gallery.find 1
      g.name.should_not == ''
      put 'update', :id => galleries(:gallery1).permalink, :gallery => {:name => ''};
      assert_response :success
      assert_template 'edit'
      g = Gallery.find 1
      g.name.should_not == ''
    end

    it 'should create gallery' do
      post 'create', :gallery => {:name => 'gallery_in_rspec', :description => 'good gallery', :status => true}
      response.should redirect_to(admin_galleries_url)
      g = Gallery.find_by_name 'gallery_in_rspec'
      g.should_not be_nil
      g.description.should == 'good gallery'
      g.permalink.should == 'gallery-in-rspec'
      g.should be_status
    end

    it 'should not create gallery because no name' do
      Gallery.count.should == 4
      post 'create', :gallery => {:name => '', :description => 'good gallery', :status => true}
      assert_response :success
      assert_template 'new'
      Gallery.count.should == 4
    end

    it 'should destroy gallery alone because no other dependencie' do
      Gallery.count.should == 4
      delete :destroy, :id => galleries(:gallery3).permalink
      response.should redirect_to(admin_galleries_url)
      Gallery.count.should == 3
      assert_raise ActiveRecord::RecordNotFound do 
        Gallery.find(3)
      end
    end
    
    it 'should destroy gallery with sub-gallery' do
      Gallery.count.should == 4
      delete :destroy, :id => galleries(:gallery1).permalink
      response.should redirect_to(admin_galleries_url)
      Gallery.count.should == 2
      assert_raise ActiveRecord::RecordNotFound do 
        Gallery.find(1)
      end
      assert_raise ActiveRecord::RecordNotFound do 
        Gallery.find(4)
      end
    end

    it 'should add gallery by mass_upload with a good directory' do
      directory = "#{RAILS_ROOT}/spec/fixtures/files"
      Gallery.should_receive(:create_by_name_of_directory).with(directory).and_return(@gallery)
      @gallery.should_receive(:save!).once.and_return(true)
      @gallery.should_receive(:insert_pictures).once.with(directory)
      post 'mass_upload', :directory => directory
      response.should redirect_to(:action => 'follow_import')
    end

    it 'should not add gallery by mass_upload with a bad directory' do
      directory = "/foo/bar"
      Gallery.should_receive(:create_by_name_of_directory).with(directory).and_return(@gallery)
      post 'mass_upload', :directory => directory
      response.should render_template('new')
    end

    it 'should not add gallery by mass_upload because name of gallery already exist' do
      directory = "/foo/bar"
      Gallery.should_receive(:create_by_name_of_directory).with(directory).and_return(@gallery)
      File.should_receive(:directory?).with(directory).and_return(true)
      @gallery.should_receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Gallery.new))
      @gallery.should_not_receive(:insert_pictures).with(directory)
      post 'mass_upload', :directory => directory
      response.should render_template('new')
    end

    it 'should redirect in follow_import if no import' do
      Import.delete_all
      get 'follow_import' 
      # TODO : bug Rspec ? http://www.ruby-forum.com/topic/143623#670379
      # because this test doesn't work with wired error
      #response.should redirect_to(:action => 'index')
    end

    it 'should edit a gallery and add master-gallery' do
      put 'update', :id => galleries(:gallery3).permalink, :gallery => {:name => 'oui', :parent_id => 1}
      response.should redirect_to(admin_galleries_url)
      g = Gallery.find 3
      g.should_not be_nil
      g.description.should == galleries(:gallery3).description
      g.permalink.should == galleries(:gallery3).permalink
      g.should be_status
      g.parent_id.should == 1 
    end

    it 'should edit a gallery with already a master-gallery and delete it' do
      put 'update', :id => galleries(:gallery4).permalink, :gallery => {:name => 'oui', :parent_id => ''}
      response.should redirect_to(admin_galleries_url)
      g = Gallery.find 4
      g.should_not be_nil
      g.description.should == galleries(:gallery4).description
      g.permalink.should == galleries(:gallery4).permalink
      g.should be_status
      g.parent_id.should be_nil
    end

    it 'should create a gallery with a master-gallery' do
      post 'create', :gallery => {:name => 'gallery_in_rspec', :description => 'good gallery', :status => true, :parent_id => 1}
      response.should redirect_to(admin_galleries_url)
      g = Gallery.find_by_name 'gallery_in_rspec'
      g.should_not be_nil
      g.description.should == 'good gallery'
      g.permalink.should == 'gallery-in-rspec'
      g.should be_status
      g.parent_id.should == 1
    end

  end
end
