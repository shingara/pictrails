require File.dirname(__FILE__) + '/../spec_helper'

describe Gallery, "with fixtures loaded" do
  fixtures :galleries, :pictures, :thumbnails

  before(:each) do
    # Set up after insert fixtures
    @gallery = mock_model(Gallery)
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

  it 'should create a gallery by a directory' do
    g = Gallery.create_by_name_of_directory('/foo/bar/gal')
    g.name.should == 'gal'
    g.description.should == ''
    g.status.should be_true
  end

  after(:each) do
    # fixtures are torn down after this
  end

end
