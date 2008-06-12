require File.dirname(__FILE__) + '/../spec_helper'

describe GalleriesController, 'first login without gallery' do
  controller_name :galleries

  before(:each) do
    User.delete_all
  end

  it 'should redirect to signup in index galleries' do
    get 'index'
    response.should redirect_to(admin_signup_url)
  end

  it 'should redirect to signup in show galleries' do
    #gallery1 is a permalink of a gallery exist
    get 'show', :id => 'gallery1'
    response.should redirect_to(admin_signup_url)
  end
end

describe 'GalleriesController there are a user' do
  controller_name :galleries
  fixtures :users, :galleries, :pictures, :thumbnails

  it 'should be not redirect to signup' do
    get 'index'
    response.should_not redirect_to(admin_signup_url)
  end
  
  it 'should be not redirect to signup in show galleries' do
    get 'show', :id => galleries(:gallery1).permalink
    response.should_not redirect_to(admin_signup_url)
  end
  
  it 'should be return a 404 because no gallery with this id' do
    get 'show', :id => 'unknowgallery'
    response.response_code.should  == 404
  end

  it 'should be redirect_to gallery list because gallery status is disabled' do
    get 'show', :id => galleries(:gallery2).permalink
    response.should redirect_to(galleries_url)
  end

end

describe GalleriesController, 'should view the pagination' do
  controller_name :galleries
  fixtures :users, :galleries, :pictures, :thumbnails
  integrate_views

  before(:each) do
    set = Setting.default
    set.galleries_pagination = 1
    set.save
  end

  it 'should see the pagination' do
    get 'index'
    response.should have_tag('div.pagination') do
      with_tag 'a[rel=next][href=/galleries/page/2]'
    end
  end
  
  it 'should not see the pagination' do
    # desactive the 2 galleries to have only one gallery
    g = Gallery.find 3
    g.status = false
    g.save

    get 'index'
    response.should_not have_tag('div.pagination') do
      with_tag 'a[rel=next][href=/galleries/page/2]'
    end
  end
end

describe GalleriesController, 'should view the pagination when you show a galleries' do
  controller_name :galleries
  fixtures :users, :galleries, :pictures, :thumbnails
  integrate_views

  before(:each) do
    set = Setting.default
    set.pictures_pagination = 1
    set.galleries_pagination = 1
    set.save
  end

  it 'should see the pagination' do
    get 'show', :id => 'gallery1'
    response.should have_tag('div.pagination') do
      with_tag 'a[rel=next][href=/galleries/gallery1/page/2]'
    end
  end
  
  it 'should not see the pagination' do
    set = Setting.default
    set.pictures_pagination = 5
    set.save

    get 'show', :id => 'gallery1'
    response.should_not have_tag('div.pagination') do
      with_tag 'a[rel=next][href=/galleries/gallery1/page/2]'
    end
  end
end

describe GalleriesController, 'View the subgallery' do
  controller_name :galleries
  fixtures :users, :galleries, :pictures, :thumbnails
  integrate_views

  before(:each) do
    @gallery1 = mock_model Gallery
    @gallery2 = mock_model Gallery
    @user = mock_model User
    User.should_receive(:count).and_return(1)
  end

  it 'should see only gallery with no parent' do
    get "index"
    response.should have_tag("td#gallery_1")
    response.should_not have_tag("td#gallery_2")
    response.should have_tag("td#gallery_3")
    response.should_not have_tag("td#gallery_4")
  end

  it 'should see all sub-gallery in view of gallery' do
    get "show", :id => galleries(:gallery1).permalink

    response.should have_tag("table#picture_list")do
      with_tag "td#gallery_4"
      with_tag "td.sub_gallery"
    end
  end
end
