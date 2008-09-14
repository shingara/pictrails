require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController do
  controller_name 'admin/comments'

  describe 'with user admin' do
    
    include AuthenticatedTestHelper

    before :each do
      login_as :quentin 
      @comment = mock_model(Comment, :id => rand(30000))
    end

    describe 'action index' do

      it 'should see all comment' do
        get 'index'
        response.should be_success
        response.should render_template('admin/comments/index')
      end

    end

    describe 'action show' do

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

    describe 'action destroy' do
      
      it 'should not destroy if not post action' do
        Comment.should_not_receive(:find).with(@comment.id.to_s).and_return(@comment)
        get 'destroy', :id => @comment.id
        response.should redirect_to(admin_comments_url)
        flash[:notice].should == "you can't destroy a comment by get request"
      end

      it 'should destroy comment if good param' do
        Comment.should_receive(:find).with(@comment.id.to_s).and_return(@comment)
        @comment.should_receive(:destroy).and_return(true)
        delete 'destroy', :id => @comment.id
        response.should redirect_to(admin_comments_url)
        flash[:notice].should == "Comment #{@comment.id} is destroy"
      end
      
      it 'should render 404 if no id exist' do
        Comment.should_receive(:find).with(4000000.to_s).and_raise(ActiveRecord::RecordNotFound)
        lambda {
          delete 'destroy', :id => 4000000
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
