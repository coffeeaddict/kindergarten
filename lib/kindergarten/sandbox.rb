module Kindergarten
  class Sandbox
    attr_reader :child, :governess, :perimeter

    def initialize(child)
      @child     = child
      @governess = Kindergarten::HeadGoverness.new(child)

      @perimeter   = []
      def @perimeter.include?(other)
        (self.collect(&:class) & [ other.class ]).any?
      end

      @unguarded = false
    end

    def extend_perimeter(*perimeter_classes)
      perimeter_classes.each do |perimeter_class|
        # if the perimeter specifies a governess, use that - otherwise appoint
        # the head governess
        child     = self.child
        governess = perimeter_class.governess ?
          perimeter_class.governess.new(child) :
          self.governess

        perimeter = perimeter_class.new(child, governess)

        # the head governess must know all the rules
        unless governess == self.governess
          self.governess.instance_eval &perimeter_class.govern_proc
        end

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

    def method_missing(name, *args, &block)
      super
    rescue NoMethodError => ex
      @perimeter.each do |perimeter|
        if perimeter.sandbox_methods.include?(name)
          return perimeter.governed(name, @unguarded) do
            perimeter.send(name, *args, &block)
          end
        end
      end

      # still here? then there is no part of the perimeter that provides method
      raise ex
    end
  end
end


