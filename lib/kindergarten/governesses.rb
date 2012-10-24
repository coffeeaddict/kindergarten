module Kindergarten
  # Hash with only allowed keys
  class ScrubbedHash < Hash; end

  # Hash with only allowed keys and untainted values
  class RinsedHash < Hash; end

  module Governesses
    class << self
      attr_accessor :forbidden_keys
    end

    self.forbidden_keys = []
  end
end

require "kindergarten/governesses/head_governess"
require "kindergarten/governesses/strict_governess"
require "kindergarten/governesses/easy_governess"
