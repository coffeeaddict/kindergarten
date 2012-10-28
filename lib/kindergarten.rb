require 'cancan'
require 'active_support/core_ext'

require "kindergarten/version"
require "kindergarten/sandbox"
require "kindergarten/purpose"
require "kindergarten/perimeter"
require "kindergarten/governesses"
require "kindergarten/exceptions"

module Kindergarten
  class << self
    def sandbox(child)
      Kindergarten::Sandbox.new(child)
    end
  end
end

