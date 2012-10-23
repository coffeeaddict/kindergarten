require 'spec_helper'

describe Kindergarten::Perimeter do
  describe :class_methods do
    it "should have a :sandbox method"
    it "should return sandboxed methods"
    it "should have a :govern method"
    it "should return a govern proc"
  end

  describe :instance_methods do
    it "should have an initialize method with 2 arguments"
    it "should have a :guard method"
    it "should have an :unguarded method"
    it "should have a :scrub method"
    it "should have a :sandboxed_methods method"
  end
end
