require File.dirname(__FILE__) + '/../spec_helper'

describe CoreCharge do
  before(:each) do
    @core_charge = CoreCharge.new
  end

  it "should be valid" do
    @core_charge.should be_valid
  end
end
