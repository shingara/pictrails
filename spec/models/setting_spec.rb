require File.dirname(__FILE__) + '/../spec_helper'

describe Setting, 'without Setting'  do

  # Delete all Setting if there are anyone in database
  before :each do
    Setting.destroy_all
  end

  it 'should get default value' do
    s = Setting.new
    s.webapp_name.should == 'My own personal WebGallery'
    s.webapp_subtitle.should == ''
  end

  it 'should write webapp_name value' do
    s = Setting.new
    s.webapp_name = 'My new Gallery'
    s.webapp_name.should == 'My new Gallery'
  end
  
  it 'should write webapp_name value' do
    s = Setting.new
    s.webapp_subtitle = 'My subtitle'
    s.webapp_subtitle.should == 'My subtitle'
  end

  it 'should return a new Setting in call default' do
    Setting.default.should be_new_record
  end
end

describe Setting, 'with settings' do
  fixtures :settings

  before (:each) do
    @setting = Setting.find 1
  end

  it 'should load setting from database' do
    @setting.webapp_name.should == 'my new gallery'
    @setting.webapp_subtitle.should == 'My subtitle' 
  end

  it 'should be first setting' do
    Setting.default.should == @setting
  end

  describe '#thumbnail_size_changed' do

    it 'should detect the changed of max height thumbnails size' do
      @setting.thumbnail_max_height = 50
      @setting.should be_change_size_thumbnails
    end
    
    it 'should detect the changed of max width thumbnails size' do
      @setting.thumbnail_max_width = 50
      @setting.should be_change_size_thumbnails
    end

    it 'should detect the changed of all thumbnails size' do
      @setting.thumbnail_max_height = 50
      @setting.thumbnail_max_width = 50
      @setting.should be_change_size_thumbnails
    end
    
    it 'should detect no change thumbnails size' do
      @setting.thumbnail_max_height = 200
      @setting.thumbnail_max_width = 200
      @setting.should_not be_change_size_thumbnails
    end

  end
end
