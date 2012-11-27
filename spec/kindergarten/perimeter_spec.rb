require 'spec_helper'

describe Kindergarten::Perimeter do
  describe :class do
    it "should have a :expose method" do
      SpecPerimeter.should respond_to(:expose)
      SpecPerimeter.should respond_to(:exposed_methods)
    end
    it "should return exposed methods" do
      SpecPerimeter.exposed_methods.should_not be_empty
    end

    it "should have a :govern method" do
      SpecPerimeter.should respond_to(:govern)
      SpecPerimeter.should respond_to(:govern_proc)
    end

    it "should return a govern proc" do
      SpecPerimeter.govern_proc.should be_kind_of(Proc)
    end

    it "should return a governess" do
      SpecPerimeter.governess.should_not be_nil
    end

    it "should return a purpose" do
      SpecPerimeter.purpose.should_not be_nil
    end
  end

  describe :instance do
    it "should have an initialize method with 2 arguments" do
      SpecPerimeter.instance.method(:initialize).arity.should == 2
    end

    it "should have a :guard method" do
      SpecPerimeter.instance.should respond_to(:guard)
    end

    it "should have an :unguarded method" do
      SpecPerimeter.instance.should respond_to(:unguarded)
    end

    it "should have a :scrub method" do
      SpecPerimeter.instance.should respond_to(:scrub)
    end

    it "should have a :rinse method" do
      SpecPerimeter.instance.should respond_to(:rinse)
    end

    it "should have a :sandbox_methods method" do
      SpecPerimeter.instance.should respond_to(:sandbox_methods)
    end
  end

  describe :sandbox do
    before(:each) do
      @sandbox = Kindergarten.sandbox("child")
      @sandbox.extend_perimeter(SpecPerimeter)
    end

    it "should have the SpecPerimeter" do
      @sandbox.perimeters.collect(&:class).should include(SpecPerimeter)
    end

    it "should fill the governess" do
      @sandbox.governess.should_not be_empty
    end

    it "should have the sandboxed method" do
      @sandbox.testing.sandboxed.should eq "child"
    end

    it "should have the guarded method" do
      expect {
        @sandbox.testing.guarded
      }.to raise_error(Kindergarten::AccessDenied)
    end

    it "should not have the unboxed method" do
      expect {
        @sanbox.testing.unboxed
      }.to raise_error(NoMethodError)
    end

    it "should have the not_guarded method" do
      @sandbox.testing.not_guarded.should eq "OK"
    end

    it "should have the unsafe method" do
      expect {
        @sandbox.testing.unsafe
      }.to raise_error(Kindergarten::Perimeter::Unguarded)
    end
  end

  describe :unguarded do
    before(:each) do
      @sandbox = Kindergarten.sandbox("child")
      @sandbox.extend_perimeter(SpecPerimeter)
    end

    it "should allow the unsafe method" do
      expect {
        @sandbox.unguarded do
          @sandbox.testing.unsafe
        end
      }.to_not raise_error(Kindergarten::Perimeter::Unguarded)
    end

    it "should allow the not_guarded method" do
      expect {
        @sandbox.unguarded do
          @sandbox.testing.not_guarded
        end
      }.to_not raise_error(Kindergarten::Perimeter::Unguarded)
    end
  end
end
