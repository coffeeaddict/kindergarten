module Kindergarten
  class Sandbox
    attr_reader :child, :governess, :perimeter, :purpose

    def initialize(child)
      @child     = child
      @governess = Kindergarten::HeadGoverness.new(child)

      @purpose   = {}
      @perimeter = []
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

        raise ArgumentError.new(
          "Module must inherit from Kindergarten::Perimeter"
        ) unless perimeter.kind_of?(Kindergarten::Perimeter)

        self.extend_purpose(perimeter.class, perimeter)

        # the head governess must know all the rules
        unless governess == self.governess || perimeter_class.govern_proc.nil?
          self.governess.instance_eval(&perimeter_class.govern_proc)
        end

        @perimeter << perimeter unless @perimeter.include?(perimeter)
      end
    end
    alias_method :load_perimeter, :extend_perimeter
    alias_method :load_module, :extend_perimeter

    def extend_purpose(perimeter, instance)
      name = perimeter.purpose || raise(
        Kindergarten::Perimeter::NoPurpose.new(perimeter)
      )
      name = name.to_sym

      self.purpose[name] ||= Kindergarten::Purpose.new(name, self)
      self.purpose[name].add_perimeter(perimeter, instance)
    end

    def unguarded(&block)
      @unguarded = true
      yield
      @unguarded = false
    end

    def unguarded?
      @unguarded == true ? true : false
    end

    def allows?(action, target)
      governess.can?(action, target)
    end
    alias_method :allowed?, :allows?

    def disallows?(action, target)
      governess.cannot?(action, target)
    end
    alias_method :disallowed?, :disallows?

    # TODO: Find a purpose and call that - move this block to Purpose
    def method_missing(name, *args, &block)
      super

    rescue NoMethodError => ex
      unless purpose.has_key?(name)
        raise Kindergarten::Sandbox::NoPurposeError.new(name, self)
      end

      return purpose[name]
    end
  end
end


