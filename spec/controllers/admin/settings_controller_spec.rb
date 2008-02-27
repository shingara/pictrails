require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/settings_controller'

describe Admin::SettingsController,' without logged' do
  controller_name 'admin/settings'

  it "should not view index" do
    get 'index'
    response.should redirect_to(admin_login_url)
  end
end

describe Admin::SettingsController,' with user logged' do
  controller_name 'admin/settings'
  fixtures :users
  include AuthenticatedTestHelper
  
  before (:each) do
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
    pending do
      Setting.default.webapp_name.should_not == ''
    end
  end
end
