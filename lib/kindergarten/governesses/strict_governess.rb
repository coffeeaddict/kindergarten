module Kindergarten
  # A very strict governess, forces all the sandbox methods to use the guard
  # methods.
  #
  # @note
  #   Does not specify how to rollback when the guard method was not called,
  #   You're on your own there...
  #
  class StrictGoverness < HeadGoverness
    # Check how often the perimeter guarded something
    attr_reader :guard_count

    def initialize(child)
      super
      @guard_count = 0
    end

    # Force the use of guard inside sandbox methods
    #
    # @raise Kindergarten::Perimeter::Unguarded when the guard count did not
    #   increment during the block execution
    #
    def governed(method, &block)
      before = self.guard_count
      res    = yield

      if @unguarded != true && self.guard_count == before
        raise Kindergarten::Perimeter::Unguarded.new(
          "#{method} was executed without propper guarding"
        )
      end

      return res
    end

    # guard something and increment the guard count
    def guard(*args)
      @guard_count += 1
      super
    end

    # allow something unguarded and increment the guard count
    def unguarded(&block)
      @guard_count += 1
      super
    end
  end
end