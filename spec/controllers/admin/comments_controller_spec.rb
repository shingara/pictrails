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

    describe 'action show' do
      before :each do
        @comment = mock_model(Comment, :id => rand(30000))
      end

      it 'should see the comment with good param' do
        Comment.should_receive(:find).with(@comment.id.to_s).and_return(@comment)
        get 'show', :id => @comment.id
        response.should be_success
        response.should render_template('admin/comments/show')
      end

      it 'should render 404 if no id exist' do
        Comment.should_receive(:find).with(@comment.id.to_s).and_raise(ActiveRecord::RecordNotFound)
        lambda {
          get 'show', :id => @comment.id
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
