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
    sandbox.perimeters.should be_empty
  end

  it "should provide a extend_perimeter function" do
    sandbox = Kindergarten::Sandbox.new(:child)
    sandbox.should respond_to(:extend_perimeter)

    expect {
      sandbox.extend_perimeter(SpecPerimeter)
    }.to change {
      sandbox.perimeters.empty?
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
      puppet = @sandbox.puppets.grab_puppet
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
      }.to raise_error(Kindergarten::Perimeter::NoExposedMethods, /MethodlessModule does not expose any methods/)
    end

    it "should not load a module that has no purpose" do
      expect {
        @sandbox.load_module(PurposelessModule)
      }.to raise_error(Kindergarten::Perimeter::NoPurpose, /PurposelessModule does not have a purpose/)
    end
  end

  describe :Purpose do
    before(:each) do
      @sandbox = Kindergarten::Sandbox.new(:kid)
    end

    it "should raise error for wrong purpose" do
      expect {
        @sandbox.empty.something
      }.to raise_error(Kindergarten::Sandbox::NoPurposeError)
    end

    it "should return a hash of purposes" do
      @sandbox.purpose.should be_kind_of(Hash)
    end
  end

  describe :Mediation do
    before(:each) do
      @sandbox = Kindergarten::Sandbox.new(:kid)
      @sandbox.load_module(SpecPerimeter)
    end

    describe :subscribe do
      it "should subscribe the sandbox to events" do
        evented = false
        @sandbox.subscribe(:testing, :event) do
          evented = true
        end

        expect {
          @sandbox.testing.fire(:event)
        }.to change { evented }
      end
    end

    describe :unsubscribe do
      it "should unsubscribe the sandbox from events" do
        evented = 0
        @sandbox.subscribe(:testing, :event) do
          evented += 1
        end

        expect {
          @sandbox.testing.fire(:event)
        }.to change { evented }

        @sandbox.unsubscribe(:testing, :event)

        expect {
          @sandbox.testing.fire(:event)
        }.to_not change { evented }
     end
    end

    describe :Broadcast do
      it "should broadcast events" do
        evented = 0

        @sandbox.broadcast do |event|
          evented += 1
        end

        expect {
          @sandbox.testing.fire(:ce_ci_nest_pas_un_event)
        }.to change { evented }
      end
    end

  end
end
