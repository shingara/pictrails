require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/settings_controller'

describe Admin::SettingsController,' without logged and no import' do
  controller_name 'admin/settings'

  # Delete all Import if there are one into
  before(:each) do
    Import.delete_all
  end

  it "should not view index" do
    get 'index'
    response.should redirect_to(admin_login_url)
  end
end

describe Admin::SettingsController,' with user logged and no Import' do
  controller_name 'admin/settings'
  fixtures :users
  include AuthenticatedTestHelper
  
  before (:each) do
    Import.delete_all
    login_as :quentin
  end

  it "should view index" do
    get 'index'
    response.should be_success
    response.should render_template('index')
  end

  it 'should update settings' do
    Setting.default.webapp_name.should_not == 'new title'
    put 'update', :id => Setting.default.id, :setting => {:webapp_name => 'new title'}
    Setting.default.webapp_name.should == 'new title'
  end

  it 'should not update settings' do
    Setting.default.webapp_name.should_not == ''
    put 'update', :id => Setting.default.id, :setting => {:webapp_name => ''}
    response.should be_success
    response.should render_template('index')
    Setting.default.webapp_name.should_not == ''
  end

  it 'should delete_cache' do
    PageCache.should_receive(:sweep_all)
    get 'delete_cache'
    response.should redirect_to(admin_settings_url)
    flash[:notice].should == 'All cache is deleted' 
  end
end
