require 'spec_helper'
require 'orm_helper'

class Migration < ActiveRecord::Migration
  def up
    create_table :bars do |t|
      t.string :name
      t.text :description
      t.string :city
      t.string :street
      t.string :type
    end
    
    create_table :restaurants do |t|
      t.string  :name
      t.text    :description
      t.integer :stars
      t.decimal :avg_meal_price, :precision => 5, :scale => 2
    end
  end
end

class Bar < ActiveRecord::Base
  include Kindergarten::ORM::Governess
end

class Joint < Bar
  # for STI tests
end

class Restaurant < ActiveRecord::Base
  include Kindergarten::ORM::Governess
  
  force_rinsed
end

describe Kindergarten::ORM::ActiveRecord do
  before(:all) do
    begin
      mig = Migration.new
      mig.suppress_messages do
        mig.up
      end
      
    rescue => ex
      unless ex.message =~ /already exists/
        $stderr.puts "!!! #{ex.class}: #{ex.message}"
      end
    end
  end

  describe :Drinking do
    before(:each) do
      @sandbox = Kindergarten.sandbox(:child)
      @sandbox.extend_perimeter(DrinkingPerimeter)
    end
  
    it "should create a bar" do
      bar = nil
      expect {
        bar = @sandbox.create_bar( name: "foo", decription: "bar" )
      }.to_not raise_error
      
      bar.should be_kind_of(Bar)
    end
    
    it "should not create a bar w/o scrubbing" do
      expect {
        @sandbox.create_bar_wo( name: "foo", decription: "bar" )
      }.to raise_error(Kindergarten::ORM::Unscrubbed)    
    end
    
    it "should protect the Joint" do
      expect {
        @sandbox.create_joint( name: "foo", decription: "bar" )
      }.to raise_error(Kindergarten::ORM::Unscrubbed)    
    end
    
    it "should build a clean joint" do
      expect {
        @sandbox.build_joint(name: "clean")
      }.to_not raise_error(Kindergarten::ORM::Unscrubbed)
    end
    
    it "should not build a dirty joint" do
      expect {
        @sandbox.build_dirty_joint
      }.to raise_error(Kindergarten::ORM::Unscrubbed)
    end
    
    it "should update a bar" do
      bar = @sandbox.create_bar(name: "Whiskey Inn")
      expect {
        @sandbox.update_bar(bar, name: "Whiskey Out")
      }.to_not raise_error(Kindergarten::ORM::Unscrubbed)
    end
    
    it "should not update a dirty bar" do
      bar = @sandbox.create_bar(name: "Whiskey Inn")
      expect {
        @sandbox.update_bar_dirty(bar, name: "Whiskey Out")
      }.to raise_error(Kindergarten::ORM::Unscrubbed)
    end    
  end
  
  describe :Dining do
    before(:each) do
      @sandbox = Kindergarten.sandbox(:child)
      @sandbox.extend_perimeter(DiningPerimeter)
    end
    
    it "should not create a scrubbed restaurant" do
      expect {
        @sandbox.create_restaurant_scrubbed(name: "China Wok")
      }.to raise_error(Kindergarten::ORM::Unscrubbed)
    end
    
    it "should create a rinsed restaurant" do
      expect {
        @sandbox.create_restaurant(name: "Lobster Inn")
      }.to_not raise_error(Kindergarten::ORM::Unscrubbed)
    end
  end
    
end