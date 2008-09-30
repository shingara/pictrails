require File.dirname(__FILE__) + '/../spec_helper'

class Test_Mass_Upload
  include Pictrails::MassUpload
end

describe Pictrails::MassUpload, "with fixtures loaded" do

  fixtures :imports

  before(:each) do
    @class = Test_Mass_Upload.new
    setting = Setting.default
    setting.nb_upload_mass_by_request = 5
    setting.save!
  end

  it 'should upload file 3 files from 3 imports in database' do
    assert_difference "Picture.count(:all, :conditions => ['gallery_id = ?', 1])", 3 do
      assert_difference 'Import.count', -3 do
        @class.upload_file
      end
    end
  end

  it "delete import if file doesn't exist and no create picture" do
    Import.delete_all
    Picture.delete_all
    Import.create!({:path => 'foo/bar.png', :gallery_id => galleries(:gallery1)})
    assert_difference 'Import.count', -1 do
      @class.upload_file
    end
    Picture.count(:conditions => ['title = ?', 'bar']).should == 0
  end
end
