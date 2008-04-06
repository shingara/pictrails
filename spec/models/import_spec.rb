require File.dirname(__FILE__) + '/../spec_helper'

describe Import do
  before(:each) do
    @import = Import.new
  end

  it "should be valid" do
    @import.should be_valid
  end
end
