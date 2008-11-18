require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do

  def valid_comment(options={})
    {:author => 'shingara',
      :email => 'cyril.mougel@gmail.com',
      :body => 'good body',
      :ip => '0.0.0.0',
      :picture_id => 1}.merge(options)
  end

  it 'should save if correct' do
    comment = Comment.create(valid_comment)
    comment.should be_valid
  end

  it 'should not save if bad format email' do
    comment = Comment.create(valid_comment.merge!(:email => 'badformat'))
    comment.should_not be_valid
    comment.errors.on(:email).should == 'is invalid'
  end

  it 'should be delete if picture where comment is associate is delete' do
    comment_id = Comment.create(valid_comment).id
    picture = Picture.find 1
    picture.destroy
    lambda{ Comment.find(comment_id)}.should raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should not create comment with bad picture_id' do
    comment = Comment.create(valid_comment(:picture_id => 1244))
    comment.should_not be_valid
    comment.errors.on(:picture).should == 'You need use a picture existing'
  end

end
