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

  it 'should save all pictures in directory' do
    Import.delete_all
    g = galleries(:gallery1)
    g.insert_pictures("#{RAILS_ROOT}/spec/fixtures/files/")
    Import.count(:conditions => ['gallery_id = ?', g.id]).should == 1
    i = Import.find_by_gallery_id(g.id)
    i.path.should == "#{RAILS_ROOT}/spec/fixtures/files/rails.png"
  end

  it "should doesn't save all pictures in directory because it's not a directory" do
    Import.delete_all
    g = galleries(:gallery1)
    g.insert_pictures("/foo/bar/")
    Import.count(:conditions => ['gallery_id = ?', g.id]).should == 0
  end

  after(:each) do
    # fixtures are torn down after this
  end

end
