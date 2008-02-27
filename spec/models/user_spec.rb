require File.dirname(__FILE__) + '/../spec_helper'

describe User, "with fixtures loaded" do
  fixtures :users

  it 'should create user' do
    user = create_user
    user.should be_valid
  end

  it 'should be not valid without login' do
    user = create_user :login => nil
    user.should_not be_valid
    user.errors[:login].should_not be_nil
  end
  
  it 'should be require password' do
    user = create_user :password => nil
    user.should_not be_valid
    user.errors[:password].should_not be_nil
  end
  
  it 'should be require password_confirmation' do
    user = create_user :password_confirmation => nil
    user.should_not be_valid
    user.errors[:password_confirmation].should_not be_nil
  end
  
  it 'should be require email' do
    user = create_user :email => nil
    user.should_not be_valid
    user.errors[:email].should_not be_nil
  end

  it 'should be authenticated' do
    User.authenticate('quentin', 'test').should == users(:quentin) 
  end

  it 'should not be authenticated' do
    User.authenticate('quentin', 'bad').should_not == users(:quentin)
    User.authenticate('quentin', 'bad').should be_nil
    User.authenticate('quetin', 'test').should_not == users(:quentin)
    User.authenticate('quetin', 'test').should be_nil
  end
  
  # Create a user but option argument but overide value
  def create_user(options = {})
    User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end

end

