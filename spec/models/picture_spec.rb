require File.dirname(__FILE__) + '/../spec_helper'

describe Picture, "with fixtures loaded" do
  fixtures :settings, :pictures, :thumbnails, :imports, :tags, :taggings

  it 'should define permalink like title' do
    p = Picture.new
    p.title = 'a new Picture'
    p.gallery_id = 1
    p.size = 12
    p.filename = 'ok'
    p.content_type = 'image/jpeg'
    p.save.should be_true
    p.permalink.should == 'a-new-picture'
  end

  it 'should define a permalink increment' do
    p = Picture.new
    p.title = 'MyString'
    p.gallery_id = 1
    p.size = 12
    p.filename = 'ok'
    p.content_type = 'image/jpeg'
    p.save.should be_true
    p.permalink.should == 'mystring-1'
  end

  it 'should create a picture with an import' do
    pic = Picture.create_picture_by_import(imports(:import1))
    pic.should == Picture.find_by_title('rails')
    pic.title.should == 'rails'
    pic.description.should == ''
    pic.status.should be_true
    pic.content_type.should == 'image/png'
    pic.filename.should == "rails.png"
    pic.gallery_id.should == 1
  end

  it 'should can create a picture with name like a route' do
    p = Picture.new
    p.title = 'new'
    p.gallery_id = 1
    p.size = 12
    p.filename = 'ok'
    p.content_type = 'image/jpeg'
    p.save.should be_true
    p.permalink.should == 'new-1' # because new is an url use by resources

    p = Picture.new
    p.title = 'new'
    p.gallery_id = 1
    p.size = 12
    p.filename = 'ok'
    p.content_type = 'image/jpeg'
    p.save.should be_true
    p.permalink.should == 'new-2' # because new is an url use by resources
  end

  it 'should change permalink after change title' do
    pic = pictures(:picture1)
    pic.permalink.should_not == 'oui'
    pic.gallery_id = 1
    pic.size = 12
    pic.filename = 'ok'
    pic.content_type = 'image/jpeg'
    pic.title = 'oui'
    pic.save.should be_true
    pic.permalink.should == 'oui'
  end

  describe 'Picture#old_tag : get the old tag' do

    it 'should get no old tag because no old tag and no new tag' do
      pic = pictures(:picture2)
      pic.old_tag.should be_empty
    end

    it 'should get no old tag because just add tag' do
      pic = pictures(:picture1)
      pic.tag_list = 'ko, ok, tag1'
      puts pic.old_tag
      pic.old_tag.should be_empty
    end

    it 'should get one old tag because one delete' do
      pic = pictures(:picture1)
      pic.tag_list = 'tag2'
      pic.old_tag.map(&:name).sort!.should == ['ok', 'ko'].sort
    end
    
    it 'should get one old tag because one delete after save' do
      pic = pictures(:picture1)
      pic.tag_list = 'tag2'
      pic.save
      pic.old_tag.map(&:name).sort!.should == ['ok', 'ko'].sort
    end
  end
end
