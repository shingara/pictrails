require File.dirname(__FILE__) + '/../spec_helper'

describe Picture, "with fixtures loaded" do
  fixtures :pictures, :thumbnails

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
end
