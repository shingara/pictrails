require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do

  def valid_comment
    {:author => 'shingara',
      :email => 'cyril.mougel@gmail.com',
      :body => 'good body',
      :ip => '0.0.0.0',
      :picture_id => 1}
  end

  it 'should save if correct' do
    comment = Comment.create(valid_comment)
    comment.valid?
    comment.should be_valid
  end

  it 'should not save if bad format email' do
    comment = Comment.create(valid_comment.merge!(:email => 'badformat'))
    comment.should_not be_valid
    comment.errors.on(:email).should == 'is invalid'
  end
end
