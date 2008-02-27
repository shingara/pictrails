require File.dirname(__FILE__) + '/../spec_helper'

describe Gallery, "with fixtures loaded" do
  fixtures :galleries, :pictures, :thumbnails

  before(:each) do
    # Set up after insert fixtures
  end
  
  it "should have a non-empty collection of galleries" do
    Gallery.find(:all).should_not be_empty
  end

  it "should have only one element in gallery 1" do
    Gallery.find(1).pictures.enable_size.should == 1 
  end

  it "should have two elements in gallery 2" do
    Gallery.find(1).pictures.size.should == 2
  end

  after(:each) do
    # fixtures are torn down after this
  end

end
