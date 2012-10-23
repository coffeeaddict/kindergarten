class Kindergarten
  class Perimeter
    class << self
      attr_reader :sandboxed_methods, :govern_proc

      def sandbox(*list)
        @sandboxed_methods |= list
      end

      def govern(proc)
        @govern_proc = proc
      end
    end
  end

  attr_reader :child, :governess

  def initialize(child, governess)
    @child     = child
    @governess = governess

    @governess.instance_eval(self.class.govern_proc)
  end

  def sandboxed_methods
    self.class.sandboxed_methods
  end
end
