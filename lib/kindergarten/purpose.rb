module Kindergarten
  # Keep track of a single purpose
  class Purpose
    attr_reader :name, :methods

    def initialize(name, sandbox)
      @name          = name
      @sandbox       = sandbox
      @methods       = {}
      @subscriptions = []
    end

    def add_perimeter(perimeter)
      perimeter.exposed_methods.each do |name|
        if @methods.has_key?(name)
          warn "WARNING: overriding already defined sandbox method #{@name}.#{name}"
        end

        @methods[name] = perimeter
      end
    end

    # TODO: Move sandbox#method_missing to here
  end
end
