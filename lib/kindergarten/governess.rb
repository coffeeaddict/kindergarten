module Kindergarten
  class Governess
    include CanCan::Ability

    def initialize(child)
      @child       = child
      @guard_count = 0
      @unguarded   = false
    end

    def guard(action, target)
      unless unguarded?
        raise Kindergarten::AccessDenied.new("x") if cannot?(action, target)
      end

      @guard_count += 1

      # to allow
      #   def project(id)
      #     project = Project.find(id)
      #     guard(;view, project)
      #   end
      #
      return target
    end

    def unguarded(&block)
      @guard_count += 1
      if block_given?
        @unguarded = true
        yield
        @unguarded = false
      end
    end

    def unguarded?
      @unguarded == true
    end
  end
end
