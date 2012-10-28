module Kindergarten
  # Signals unallowed access
  class AccessDenied < CanCan::AccessDenied
    def initialize(action, target, opts)
      message = opts.delete(:message)
      if message.blank?
        name    = target.is_a?(Class) ? target.name : target.class.name
        message = "You are not allowed to #{action} that #{name.downcase}"
      end

      super(message, action, target)
    end
  end

  class Sandbox
    class NoPurposeError < NoMethodError
      def initialize(purpose, sandbox)
        @purpose = purpose
        @sandbox = sandbox
      end

      def to_s
        "undefined purpose '#{@purpose}' for #{@sandbox}"
      end
    end
  end

  class Perimeter
    class NoExposedMethods < NoMethodError
      def initialize(perimeter)
        @perimeter = perimeter
        super
      end

      def to_s
        "The module #{@perimeter.name} does not expose any methods."
      end
    end

    class NoPurpose < ArgumentError
      def initialize(perimeter)
        @perimeter = perimeter
        super
      end

      def to_s
        "The module #{@perimeter.name} does not have a purpose."
      end
    end

    # Signals bad sandbox method implementation
    class Unguarded < SecurityError; end
  end
end
