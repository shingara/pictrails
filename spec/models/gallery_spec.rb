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
    Gallery.find(1).pictures.enable_size.should == 2 
  end

  it "should have two elements in gallery 3" do
    Gallery.find(1).pictures.size.should == 3
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
    Import.count(:conditions => ['gallery_id = ?', g.id]).should == 2
    imports = Import.find_all_by_gallery_id(g.id).group_by(&:path)
    imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/rails.png")
    imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo.png")
    imports.each do |k,v|
      v.should have(1).items
      v[0].total.should == 2
    end
  end
  
  it 'should save all pictures in directory if there are no / in end of directory' do
    Import.delete_all
    g = galleries(:gallery1)
    g.insert_pictures("#{RAILS_ROOT}/spec/fixtures/files")
    Import.count(:conditions => ['gallery_id = ?', g.id]).should == 2
    imports = Import.find_all_by_gallery_id(g.id).group_by(&:path)
    imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/rails.png")
    imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo.png")
    imports.each do |k,v|
      v.should have(1).items
      v[0].total.should == 2
    end
  end

  it "should doesn't save all pictures in directory because it's not a directory" do
    Import.delete_all
    g = galleries(:gallery1)
    g.insert_pictures("/foo/bar/")
    Import.count(:conditions => ['gallery_id = ?', g.id]).should == 0
  end

  it 'should retrieve all without himself' do
    g = Gallery.find_without(galleries(:gallery1))
    g.should have(3).items
    g.should_not be_include(galleries(:gallery1))
  end

  after(:each) do
    # fixtures are torn down after this
  end

end
