require File.dirname(__FILE__) + '/../spec_helper'

describe Setting, 'without Setting'  do

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
end

describe Setting, 'with settings' do
  fixtures :settings

  it 'should load setting from database' do
    s = Setting.find 1
    s.webapp_name.should == 'my new gallery'
    s.webapp_subtitle.should == 'My subtitle' 
  end

  it 'should be first setting' do
    Setting.default.should == Setting.find(1)
  end
end
