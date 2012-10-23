require 'cancan'

require "kindergarten/version"
require "kindergarten/sandbox"
require "kindergarten/exceptions"
require "kindergarten/governess"
require "kindergarten/perimeter"

module Kindergarten
  class << self
    def sandbox(child)
      Kindergarten::Sandbox.new(child)
    end
  end
end

