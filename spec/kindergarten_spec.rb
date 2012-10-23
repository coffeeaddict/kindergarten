require 'spec_helper'

describe Kindergarten do
  it "should have a version constant" do
    Kindergarten::VERSION.should_not be_nil
  end

  it "should have a sandbox method" do
    res = Kindergarten.sandbox("string")
    res.should be_kind_of(Kindergarten::Sandbox)
  end
end
