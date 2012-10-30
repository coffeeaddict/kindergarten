require 'spec_helper'
require 'stringio'

describe Kindergarten::Purpose do
  before(:each) do
    @sandbox = Kindergarten.sandbox(:child)
  end

  it "should register the methods of a perimeter" do
    purpose = Kindergarten::Purpose.new(:test, @sandbox)

    expect {
      purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))
    }.to change {
      purpose.methods
    }
  end

  it "should warn on duplicate methods" do
    purpose = Kindergarten::Purpose.new(:test, @sandbox)
    purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))

    $stderr = StringIO.new
    expect {
      purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))
    }.to change {
      $stderr.length
    }
  end

  it "should fail on restricted methods" do
    purpose = Kindergarten::Purpose.new(:test, @sandbox)
    expect {
      purpose.add_perimeter(IllegalModule, IllegalModule.instance(:child))
    }.to raise_error(Kindergarten::Perimeter::RestrictedMethodError)
  end

  it "should delegate method execution to the perimeter" do
    purpose   = Kindergarten::Purpose.new(:test, @sandbox)
    perimeter = SpecPerimeter.instance(:child, @sandbox.governess)
    purpose.add_perimeter(SpecPerimeter, perimeter)

    expect {
      purpose.evented
    }.to change {
      perimeter.evented?
    }
  end
end
