require File.dirname(__FILE__) + '/../spec_helper'

describe Pictrails::ImportSystem do

  describe 'search in /app/controllers where there are one directory inside' do

    before(:each) do
      @gallery_import = Pictrails::ImportSystem.search("#{RAILS_ROOT}/app/controllers")
    end

    it 'should be a GalleryImport return' do
      @gallery_import.should be_kind_of(Pictrails::ImportSystem::GalleryImport)
    end

    it 'should be a name controller' do
      @gallery_import.name.should == 'controllers'
    end

    it 'should have no parent' do
      @gallery_import.parent.should be_nil
    end

    it 'should be a path #{RAILS_ROO}/app/controller' do
      @gallery_import.path.should == "#{RAILS_ROOT}/app/controllers"
    end

    it 'should have a child' do
      @gallery_import.should have(1).child
    end

    it 'should have a child with name admin' do
      @gallery_import.child[0].name.should == 'admin'
    end

    it 'should have a child with a parent who is the GalleryImport' do
      @gallery_import.child[0].parent.should == @gallery_import
    end

  end

  describe 'search in /app/controllers/admin where there are no directory inside' do
    before(:each) do
      @gallery_import = Pictrails::ImportSystem.search("#{RAILS_ROOT}/app/controllers/admin")
    end

    it 'should be a GalleryImport return' do
      @gallery_import.should be_kind_of(Pictrails::ImportSystem::GalleryImport)
    end

    it "should be a name 'admin'" do
      @gallery_import.name.should == 'admin'
    end

    it 'should be a path #{RAILS_ROO}/app/controllers/admin' do
      @gallery_import.path.should == "#{RAILS_ROOT}/app/controllers/admin"
    end

    it 'should have no child' do
      @gallery_import.should have(0).child
    end
    
    it 'should have no parent' do
      @gallery_import.parent.should be_nil
    end

  end
  
  describe 'search in /app/ where there are several directory inside and directory inside directory' do
    before(:each) do
      @gallery_import = Pictrails::ImportSystem.search("#{RAILS_ROOT}/app/")
    end

    it 'should be a GalleryImport return' do
      @gallery_import.should be_kind_of(Pictrails::ImportSystem::GalleryImport)
    end

    it "should be a name 'admin'" do
      @gallery_import.name.should == 'app'
    end

    it 'should be a path #{RAILS_ROOT}/app/' do
      @gallery_import.path.should == "#{RAILS_ROOT}/app/"
    end

    it 'should have 5 childs' do
      @gallery_import.should have(5).child
    end
    
    it 'should have no parent' do
      @gallery_import.parent.should be_nil
    end

    it 'should have child to controllers' do
      test = false
      @gallery_import.child.each do |child|
        test = true if child.name == 'controllers'
      end
      test.should be_true
    end

    it 'should have a child controllers with a child admin' do
      @gallery_import.child.each do |child|
        if child.name == 'controllers'
          child.child[0].name.should == 'admin'
        end
      end
    end

  end
end
