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

  describe 'the new_empty method' do

    before(:each) do
      @gallery = Gallery.new_empty
    end

    it 'should status true' do
      @gallery.status.should be_true
    end

    it 'should description empty' do
      @gallery.description.should be_empty
    end

    it 'should not valid to save' do
      @gallery.should_not be_valid
    end
  end

  describe 'the create_from_directoy method' do

    describe "when it's not a directory" do
      before(:each) do
        Import.delete_all
        @gallery = Gallery.create_from_directory("/failed_directory")
      end

      it 'should be nil' do
        @gallery.should be_nil
      end

      it 'should not be import save' do
        Import.count.should == 0
      end
    end

    describe 'when several recursive directory' do
      before(:each) do
        Import.delete_all
        @gallery = Gallery.create_from_directory("#{RAILS_ROOT}/app/")
      end

      it "should have name 'app'" do
        @gallery.name.should == 'app'
      end

      it "should have 5 children" do
        @gallery.should have(5).children
      end

      it "should have child with controllers name" do
        @gallery.children.group_by(&:name).keys.should be_include('controllers')
      end

      it "should have child controllers with a child admin" do
        gallery = @gallery.children.group_by(&:name)['controllers'][0]
        gallery.children.group_by(&:name).keys.should be_include('admin')
      end
      it "should have child controllers who have app like parent" do
        gallery = @gallery.children.group_by(&:name)['controllers'][0]
        gallery.parent.should == @gallery
      end

      it "should not have import in database because no picture in directory" do
        Import.count.should == 0
      end

    end

    describe 'when a directory has name already in use' do
      before(:each) do
        Gallery.delete_all
        Gallery.create_from_directory("#{RAILS_ROOT}/app/controllers/admin")
      end

      it 'should change name with -1 after' do
        Gallery.find_by_name 'admin-1'
      end

      it 'should change name with -2 if -1 already use' do
        Gallery.create_from_directory("#{RAILS_ROOT}/app/controllers/admin")
        Gallery.find_by_name 'admin-2'
      end
    end

    describe 'when only one directory' do
      before(:each) do 
        Import.delete_all
        @gallery = Gallery.create_from_directory("#{RAILS_ROOT}/app/controllers/admin")
      end

      it 'should have no child' do
        @gallery.should have(0).child
      end

      it "should have name 'admin'" do
        @gallery.name.should == 'admin'
      end

      it "should have permalink 'admin'" do
        @gallery.permalink.should == "admin"
      end

      it "should have a empty description" do
        @gallery.description.should be_empty
      end

      it "should have a status true" do
        @gallery.status.should be_true
      end

      it "should be valid" do
        @gallery.should be_valid
      end
      
      it "should not have import in database because no picture in directory" do
        Import.count.should == 0
      end

    end

    describe "when there are picture in directory" do
      before(:each) do
        Import.delete_all
        @gallery = Gallery.create_from_directory("#{RAILS_ROOT}/spec/fixtures/files")
      end

      it 'should have 3 Imports save' do
        Import.count.should == 3
      end

      it 'each import should have the same gallery_id' do
        imports = Import.find :all
        imports[0].gallery_id.should == imports[1].gallery_id
      end
    end
  end

  describe 'test the insert_pictures method' do

    before(:each) do
      Import.delete_all
      @gallery = galleries(:gallery1)
    end

    it 'should save all pictures in directory' do
      @gallery.insert_pictures("#{RAILS_ROOT}/spec/fixtures/files/")
      Import.count(:conditions => ['gallery_id = ?', @gallery.id]).should == 3
      imports = Import.find_all_by_gallery_id(@gallery.id).group_by(&:path)
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/rails.png")
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo.png")
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo-2.PNG")
      imports.each do |k,v|
        v.should have(1).items
        v[0].total.should == 3
      end
    end
    
    it 'should save all pictures in directory if there are no / in end of directory' do
      @gallery.insert_pictures("#{RAILS_ROOT}/spec/fixtures/files")
      Import.count(:conditions => ['gallery_id = ?', @gallery.id]).should == 3
      imports = Import.find_all_by_gallery_id(@gallery.id).group_by(&:path)
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/rails.png")
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo.png")
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo-2.PNG")
      imports.each do |k,v|
        v.should have(1).items
        v[0].total.should == 3
      end
    end

    it "should doesn't save all pictures in directory because it's not a directory" do
      @gallery.insert_pictures("/foo/bar/")
      Import.count(:conditions => ['gallery_id = ?', @gallery.id]).should == 0
    end

    it 'should see files with sensitive case' do
      @gallery.insert_pictures("#{RAILS_ROOT}/spec/fixtures/files")
      Import.count(:conditions => ['gallery_id = ?', @gallery.id]).should == 3
      imports = Import.find_all_by_gallery_id(@gallery.id).group_by(&:path)
      imports.keys.should be_include("#{RAILS_ROOT}/spec/fixtures/files/foo-2.PNG")
    end
  end

  it 'should retrieve all without himself' do
    g = Gallery.find_without(galleries(:gallery1))
    g.should have(3).items
    g.should_not be_include(galleries(:gallery1))
  end

  it 'should no use permalink who can match with a route' do
    g = Gallery.new
    g.name = "new"
    g.should be_valid
    g.permalink.should == "new-1"
    g.save.should be_true
    g.permalink.should == "new-1"
  end

  after(:each) do
    # fixtures are torn down after this
  end

end
