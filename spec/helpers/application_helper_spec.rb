require File.dirname(__FILE__) + '/../spec_helper'

describe "ApplicationHelper" do
  helper_name 'application'

  it 'status should be active' do
    status_value(true).should == 'Active'
  end

  it 'status should be disabled' do
    status_value(false).should == 'Disabled'
  end

  it 'page_title should be not define' do
    page_title.should == 'title'
  end

  it 'page_title should be define' do
    @page_title = 'action'
    page_title.should == "title - action"
  end

  it 'flash[:notice] should not be display' do
    flash_notice.should be_empty
  end

  it 'flash[:notice] should be display' do
    flash[:notice] = 'hello'
    flash_notice.should == '<p class="notice">hello</p>'
  end

  Struct.new("Webapp", :webapp_name, :webapp_subtitle)

  def this_webapp
    Struct::Webapp.new('title', 'subtitle')
  end
end
