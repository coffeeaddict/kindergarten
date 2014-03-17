require 'cancan/ability'
require 'cancan/rule'
require 'cancan/model_additions'
require 'cancan/exceptions'
require 'cancan/model_adapters/abstract_adapter'
require 'cancan/model_adapters/default_adapter'
require 'cancan/model_adapters/active_record_adapter' if defined? ActiveRecord
require 'cancan/model_adapters/data_mapper_adapter' if defined? DataMapper
require 'cancan/model_adapters/mongoid_adapter' if defined?(Mongoid) && defined?(Mongoid::Document)

require 'active_support/core_ext'

require "kindergarten/version"
require "kindergarten/sandbox"
require "kindergarten/purpose"
require "kindergarten/event"
require "kindergarten/perimeter"
require "kindergarten/governesses"
require "kindergarten/exceptions"

module Kindergarten
  class << self
    attr_accessor :warnings
    def sandbox(child)
      Kindergarten::Sandbox.new(child)
    end

    def warning(msg)
      return if @warnings == false
      return warning("Empty warning message") if msg.nil?

      warn("WARNING: #{msg}")
    end
  end
end

