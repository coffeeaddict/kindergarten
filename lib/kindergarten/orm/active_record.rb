module Kindergarten::ORM
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def update_attributes(hash)
      self.class.check(:update_attributes, hash)
    end
    
    module ClassMethods
      def create(*args)
        check(:create, *args)
        super
      end
      
      def new(*args)
        check(:new, *args)
        super
      end
      
      def check(method, *args)
        required = self.force_rinsed? ?
          Kindergarten::RinsedHash : 
          Kindergarten::ScrubbedHash

        if args[0].is_a?(Array)
          args.each do |input|
            raise Unscrubbed unless input.is_a?(required) 
          end

        elsif args[0].is_a?(Hash)
          raise Unscrubbed unless args[0].is_a?(required)
          
        elsif args.any?
          warn "WARNING: #{self.name}.#{method} called with unkown signature"
          
        end
      end
    end
  end
end
