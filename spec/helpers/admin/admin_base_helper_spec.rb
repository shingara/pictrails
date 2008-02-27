require File.dirname(__FILE__) + '/../../spec_helper'

describe "ApplicationHelper" do
  helper_name 'admin/base'
  
  it 'page_title should be not define' do
    page_title_admin.should == 'Pictrails - Administration'
  end

  it 'page_title should be define' do
    @page_title = 'action'
    page_title_admin.should == "Pictrails - Administration - action"
  end

end
