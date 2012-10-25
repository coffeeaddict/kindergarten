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

  describe :HeadGoverness do
    before(:each) do
      @sandbox = Kindergarten::Sandbox.new(:child)
      @sandbox.extend_perimeter(SpecPerimeter, PuppetPerimeter)
    end

    it "should tell the outside what is allowed" do
      @sandbox.should be_allowed(:view, "string")
    end

    it "should know the rules accross perimeters" do
      puppet = @sandbox.grab_puppet
      @sandbox.should be_disallowed(:bbq, puppet)
    end
  end

  describe :Loading do
    before(:each) do
      @sandbox = Kindergarten::Sandbox.new(:child)
    end

    it "should not load a module that has no sandboxed methods" do
      expect {
        @sandbox.load_module(MethodlessModule)
      }.to raise_error(Kindergarten::NoExposedMethods)
    end

    it "should not load a module that has no purpose" do
      expect {
        @sandbox.load_module(PurposelessModule)
      }.to raise_error(Kindergarten::NoPurpose)
    end
  end
end
