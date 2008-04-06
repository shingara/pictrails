require File.dirname(__FILE__) + '/../spec_helper'

describe Picture, "with fixtures loaded" do
  fixtures :settings, :pictures, :thumbnails, :imports

  it 'should define permalink like title' do
    p = Picture.new
    p.title = 'a new Picture'
    p.define_permalink
    p.permalink.should == 'a-new-picture'
  end

  it 'should define a permalink increment' do
    p = Picture.new
    p.title = 'MyString'
    p.define_permalink
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
end
