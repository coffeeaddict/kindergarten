require 'cancan'

require "kindergarten/version"
require "kindergarten/exceptions"
require "kindergarten/governess"
require "kindergarten/perimeter"

class Kindergarten
  attr_reader :child, :governess

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
    governess.unguarded do
      yield(self)
    end
    @unguarded = false
  end

  def force_guard(&block)
    before = governess.guard_count.dup
    res    = yield

    if @unguarded == true || governess.guard_count == before
      raise "Unguarded sandbox method invoked"
    end

    return res
  end


  def method_missing(name, *args, &block)
    super

  rescue NoMethodError => ex
    @perimeter.each do |object|
      if object.sandbox_methods.include?(name)
        return force_guard do
          object.send(name, *args, &block)
        end
      end
    end

    # still here? then there is no psrt of the erimeter that provides method
    raise ex
  end
end
