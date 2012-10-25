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

  class Kindergarten::NoExposedMethods < RuntimeError
    def to_s
      "You tried to load a module which does not call the #sandbox method"
    end
  end

  class Kindergarten::NoPurpose < RuntimeError
    def to_s
      "You tried to load a module which does not call the #purpose method"
    end
  end

  class Perimeter
    # Signals bad sandbox method implementation
    class Unguarded < SecurityError; end
  end
end
