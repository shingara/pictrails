require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/sessions_controller'

describe Admin::SessionsController, 'without user in BDD' do
  controller_name 'admin/sessions'
  fixtures :users
  include AuthenticatedTestHelper

  it 'should see new' do
    get 'new'
    response.should be_success
    response.should render_template('new')
  end

  it 'should create session' do
    post 'create', :login => 'quentin', :password => 'test'
    session[:user_id].should_not be_nil
    response.should redirect_to(admin_galleries_url)
  end

  it 'should not create session because bad password' do
    post 'create', :login => 'quentin', :password => 'oui'
    session[:user_id].should be_nil
    response.should be_success
    response.should render_template('new')
  end

  it 'should destroy session' do
    login_as :quentin
    session[:user_id].should_not be_nil
    delete 'destroy'
    session[:user_id].should be_nil
    response.should redirect_to(root_url)
  end

end
