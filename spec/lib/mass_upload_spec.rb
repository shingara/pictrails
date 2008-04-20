require File.dirname(__FILE__) + '/../spec_helper'

class Test_Mass_Upload
  include Pictrails::MassUpload
end

describe Pictrails::MassUpload, "with fixtures loaded" do

  fixtures :imports

  before(:each) do
    @class = Test_Mass_Upload.new
  end

  it 'should upload file' do
    Picture.count(:all, :conditions => ['gallery_id = ?', 1]).should == 2
    Import.count(:all).should == 1
    @class.upload_file
    Import.count(:all).should == 0
    Picture.count(:all, :conditions => ['gallery_id = ?', 1]).should == 3
  end

  it "delete import if file doesn't exist" do
    Import.create!({:path => 'foo/bar.png'})
    Import.count(:all).should == 2
    @class.upload_file
    Import.count(:all).should == 0
    Picture.count(:conditions => ['title = ?', 'bar']).should == 0
  end
end
