require 'cancan'
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

