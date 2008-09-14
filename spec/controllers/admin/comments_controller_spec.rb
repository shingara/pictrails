require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do
  controller_name 'admin/comments'

  describe 'with user admin' do
    
    include AuthenticatedTestHelper

    before :each do
     login_as :quentin 
    end

    describe 'action index' do

      it 'should see all comment' do
        get 'index'
        response.should be_success
        response.should render_template('admin/comments/index')
      end

    end
  end
end
