require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/users_controller'

describe Admin::UsersController, 'without user in BDD' do
  controller_name 'admin/users'

  before(:each) do
    User.delete_all
  end

  it 'should see new' do
    get 'new'
    response.should be_success
    response.should render_template('new')
  end

  it 'should create user' do
    User.count.should == 0
    post 'create', :user => {:password => 'itscool', :password_confirmation => 'itscool', :login => 'shingara', :email => 'shingara@gmail.com'}
    response.should redirect_to(admin_galleries_url)
    User.count.should == 1
    User.find_by_login('shingara').email.should == 'shingara@gmail.com'
  end

  it 'should not create user because bad password_confirmation' do 
    User.count.should == 0
    post 'create', :user => {:password => 'itscool', :password_confirmation => 'scool', :login => 'shingara', :email => 'shingara@gmail.com'}
    User.count.should == 0
  end

end

describe Admin::UsersController, 'with user in BDD' do
  controller_name 'admin/users'
  fixtures :users
  include AuthenticatedTestHelper

  it 'should not view new' do
    get 'new'
    response.should redirect_to(admin_login_url)
  end

  it 'should not view new if you are logged' do
    login_as :quentin
    get 'new'
    response.should redirect_to(admin_galleries_url)
  end
end
