module Kindergarten
  # Keep track of a single purpose
  class Purpose
    attr_reader :name, :methods, :sandbox, :subscriptions

    def initialize(name, sandbox)
      @name          = name
      @sandbox       = sandbox
      @methods       = {}
      @subscriptions = []
    end

    def add_perimeter(perimeter, instance)
      if perimeter.exposed_methods.blank?
        raise Kindergarten::Perimeter::NoExposedMethods.new(perimeter)
      end

      perimeter.exposed_methods.each do |name|
        if @methods.has_key?(name)
          warn "WARNING: overriding already sandboxed method #{@name}.#{name}"
        end

        @methods[name] = instance
      end
    end

    def method_missing(name, *args, &block)
      super

    rescue NoMethodError => ex
      unless methods.has_key?(name)
        raise ex
      end

      perimeter = methods[name]
      perimeter.governed(name, sandbox.unguarded?) do
        perimeter.send(name, *args, &block)
      end
    end
  end
end
