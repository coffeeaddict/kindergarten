require 'spec_helper'
require 'stringio'

describe Kindergarten do
  it "should have a version constant" do
    Kindergarten::VERSION.should_not be_nil
  end

  it "should have a sandbox method" do
    res = Kindergarten.sandbox("string")
    res.should be_kind_of(Kindergarten::Sandbox)
  end

  it "should have warnings" do
    Kindergarten.warnings = true
    prev = $stderr.dup
    $stderr = StringIO.new

    expect {
      Kindergarten.warning "see"
    }.to change {
      $stderr.length
    }

    $stderr = prev
    Kindergarten.warnings = false
  end
end
