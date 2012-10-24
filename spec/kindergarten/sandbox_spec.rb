require 'spec_helper'

describe Kindergarten::Sandbox do
  it "should allow an instance for any child" do
    expect {
      Kindergarten::Sandbox.new(:any)
    }.to_not raise_error
  end

  it "should know it's child" do
    sandbox = Kindergarten::Sandbox.new(:its)
    sandbox.child.should eq :its
  end

  it "should create an empty governess for the object" do
    sandbox = Kindergarten::Sandbox.new(:object)
    sandbox.governess.should be_kind_of(Kindergarten::HeadGoverness)
    sandbox.governess.should be_empty
  end

  it "should define an empty perimeter" do
    sandbox = Kindergarten::Sandbox.new(:child)
    sandbox.perimeter.should be_empty
  end

  it "should provide a extend_perimeter function" do
    sandbox = Kindergarten::Sandbox.new(:child)
    sandbox.should respond_to(:extend_perimeter)

    expect {
      sandbox.extend_perimeter(SpecPerimeter)
    }.to change {
      sandbox.perimeter.empty?
    }
  end
end
