module Kindergarten
  class Sandbox
    attr_reader :child, :governess, :perimeter

    def initialize(child)
      @child     = child
      @governess = Kindergarten::Governess.new(child)

      @perimeter   = []
      def @perimeter.include?(other)
        (self.collect(&:class) & [ other.class ]).any?
      end

      @unguarded = false
    end

    def extend_perimeter(*perimeter_classes)
      perimeter_classes.each do |perimeter_class|
        perimeter = perimeter_class.new(self.child, self.governess)

        raise ArgumentError.new(
          "Module must inherit from Kindergarten::Perimeter"
        ) unless perimeter.kind_of?(Kindergarten::Perimeter)

        @perimeter << perimeter unless @perimeter.include?(perimeter)
      end
    end

    def unguarded(&block)
      @unguarded = true
      yield
      @unguarded = false
    end

    def force_guard(name, &block)
      before = governess.guard_count
      res    = yield

      if @unguarded != true && governess.guard_count == before
        raise Kindergarten::Perimeter::Unguarded.new(
          "#{name} was executed without propper guarding"
        )
      end

      return res
    end

    def method_missing(name, *args, &block)
      super
    rescue NoMethodError => ex
      @perimeter.each do |perimeter|
        if perimeter.sandbox_methods.include?(name)
          return force_guard(name) { perimeter.send(name, *args, &block) }
        end
      end

      # still here? then there is no part of the perimeter that provides method
      raise ex
    end
  end
end


