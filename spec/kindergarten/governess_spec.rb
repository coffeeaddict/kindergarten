require 'spec_helper'

describe Kindergarten::Governess do
  before(:each) do
    @governess = Kindergarten::Governess.new("child")
  end
  
  it "should include CanCan ability" do
    @governess.should be_kind_of(CanCan::Ability)
  end
  
  describe :governing do
    it "should guard the child" do
      expect {
        @governess.guard(:free, "Willy")
      }.to raise_error(Kindergarten::AccessDenied)
    end
    
    it "should keep a closed eye" do
      expect {
        @governess.unguarded do
          @governess.guard(:free, "Willy")
        end
      }.to_not raise_error(Kindergarten::AccessDenied)
    end
  end
  
  describe :washing do
    it "should scrub attributes" do
      attr     = { a: 1, b: 2, c: 3 }

      scrubbed = @governess.scrub(attr, :a, :c)
      scrubbed.should_not be_has_key(:b)
    end
    
    it "should return a ScrubbedHash after scrubbing" do
      attr     = { a: 1, b: 2, c: 3 }

      scrubbed = @governess.scrub(attr, :a, :c)
      scrubbed.should be_kind_of(Kindergarten::ScrubbedHash)      
    end
    
    it "should rinse attributes" do
      attr   = { a: "1", b: "2a", c: "3" }
      rinsed = @governess.rinse(attr, a: /(\d+)/, b: /(\D+)/)

      rinsed.should_not be_has_key(:c)
      rinsed[:a].should eq "1"
      rinsed[:b].should eq "a"
    end
    
    it "should pass attributes" do
      attr   = { a: "1", b: "2a", c: "3" }
      rinsed = @governess.rinse(attr, a: :pass, c: :pass)
      
      rinsed.should_not be_has_key(:b)
      rinsed[:a].should eq "1"
      rinsed[:c].should eq "3"
    end
    it "should return a RinsedHash after rinsing" do
      attr   = { a: "1", b: "2a", c: "3" }
      rinsed = @governess.rinse(attr, a: /(\d+)/, b: /(\d+)/)

      rinsed.should be_kind_of(Kindergarten::RinsedHash)
    end
  end
end
