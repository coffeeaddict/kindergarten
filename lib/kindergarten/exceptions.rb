module Kindergarten
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

  class Perimeter
    class Unguarded < SecurityError; end
  end
end
