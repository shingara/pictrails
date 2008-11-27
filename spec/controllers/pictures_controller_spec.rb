require File.dirname(__FILE__) + '/../spec_helper'

describe PicturesController do
  controller_name :pictures

  before :each do
    @picture = mock_model(Picture,{ :id => rand(200000),
                                    :permalink => 'good_permalink',
                                    :gallery => mock_model(Gallery),
                                    :tag_list => [],
                                    :comments => mock("comments", { :new => mock_model(Comment)}),
                                    :to_param => 'good_permalink',
                                    :title => 'good title',
                                    :previous => nil,
                                    :next => nil,
                                    :public_filename => 'yahoo.png',
                                    :description => 'good description'
                                  })
    @gallery = mock_model(Gallery)
  end

  describe 'show action' do

    def show_picture
      get 'show', :gallery_id =>'my_permalink_gallery', :id => 'my_permalink'
    end

    before :each do
      @picture.should_receive(:permalink).and_return('my_permalink')
      @setting = mock_model(Setting)
      Setting.stub!(:default).and_return(@setting)
      @setting.stub!(:comment).and_return(true)
      @picture.stub!(:comments).and_return(Comment)
    end

    it 'should see a picture' do
      Picture.should_receive(:find_by_permalink).with(@picture.permalink).and_return(@picture)
      show_picture
      assigns(:comment).should_not be_nil
      response.should be_success
      response.should render_template('show')
    end

    it 'should not see picture and return a 400' do
      Picture.should_receive(:find_by_permalink).with(@picture.permalink).and_return(nil)
      show_picture
      assigns(:comment).should be_nil # raise 404 before
      response.response_code.should == 404
      response.should render_template("#{RAILS_ROOT}/public/404.html")
    end

    it 'not assign comment if comment desactivate' do
      Picture.should_receive(:find_by_permalink).with(@picture.permalink).and_return(@picture)
      @setting.should_receive(:comment).and_return(false)
      show_picture
      assigns(:comment).should be_nil
      response.should be_success
      response.should render_template('show')
    end

  end

  describe 'in action create_comment' do

    def valid_comment
      {:comment => {:picture_id => @picture.id,
                    :author => 'new_author',
                    :body => 'good body',
                    :email => 'good@example.com',
      }}
    end

    before :each do
      @comment = mock_model(Comment, :picture => @picture)
      Comment.stub!(:create).and_return(@comment)
      Picture.stub!(:find).with(@picture.id).and_return(@picture)
    end

    it 'should create a comment with valid comment' do
      @comment.should_receive(:ip=).with('0.0.0.0').and_return(true)
      @comment.should_receive(:save).and_return(true)
      post 'create_comment', valid_comment
      response.should redirect_to(picture_url(@picture))
      flash[:notice].should == 'Your comment is save'
    end

    it 'should not create a comment if invalid comment' do
      @comment.should_receive(:ip=).with('0.0.0.0').and_return(true)
      @comment.should_receive(:save).and_return(false)
      post 'create_comment', :comment => {:picture_id => @picture.id}
      response.should be_success
      response.should render_template('pictures/show')
      flash[:notice].should == 'Your comment failed'
    end

    it 'should not create comment if not post method' do
      get 'create_comment', valid_comment
      response.should redirect_to(picture_url(@picture))
      flash[:notice].should == 'no comment save because GET request'
    end

  end
end
