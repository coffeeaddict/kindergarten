module Kindergarten
  # Keep track of a single purpose
  class Purpose
    attr_reader :name, :methods, :sandbox, :subscriptions

    RESTRICTED_METHOD_NAMES = [ :_subscribe, :fire, :add_perimeter,
      :initialize,
    ]

    def initialize(name, sandbox)
      @name          = name
      @sandbox       = sandbox
      @methods       = {}
      @subscriptions = {}
    end

    def add_perimeter(perimeter, instance)
      if perimeter.exposed_methods.blank?
        raise Kindergarten::Perimeter::NoExposedMethods.new(perimeter)
      end

      perimeter.exposed_methods.each do |name|
        if RESTRICTED_METHOD_NAMES.include?(name)
          raise(
            Kindergarten::Perimeter::RestrictedMethodError.new(perimeter, name)
          )

        elsif @methods.has_key?(name)

          Kindergarten.warning "overriding already sandboxed method #{@name}.#{name}"
        end

        @methods[name] = instance
      end
    end

    def _subscribe(event, &block)
      @subscriptions[event] ||= []
      @subscriptions[event] << block
    end

    def _unsubscribe(event)
      @subscriptions.delete(event)
    end

    def fire(event_name, payload=nil)
      event = Kindergarten::Event.new(event_name, self.name, payload)

      if @subscriptions.has_key?(event_name)
        @subscriptions[event_name].each do |proc|
          proc.call(event)
        end
      end

      self.sandbox.broadcast!(event)
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
