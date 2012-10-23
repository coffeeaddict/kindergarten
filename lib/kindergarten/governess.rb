module Kindergarten
  # Hash with only allowed keys
  class ScrubbedHash < Hash; end
  
  # Hash with only allowed keys and untainted values
  class RinsedHash < Hash; end

  # The Governess keeps an eye on the child in the sandbox and makes sure
  # she plays nicely and within the bounds of legality
  # 
  class Governess
    class << self
      attr_accessor :forbidden_keys
    end
    
    self.forbidden_keys = []
    
    # Check how often we guarded something
    attr_reader :guard_count

    include CanCan::Ability

    def initialize(child)
      @child       = child
      @guard_count = 0
      @unguarded   = false
      @rules       = []
    end

    # The governess is empty when no rules have been defined
    def empty?
      @rules.empty?
    end
    
    # Check to see if the child can do something, increments @guard_count 
    #
    # @param action Action to take
    # @param target On given target
    # @param opts [Hash] options
    # @option opts [String] :message The message on access denied 
    #
    # @raise [Kindergarten::AccessDenied] when the kindergarten is guarded and
    #   the action is not allowed
    #   
    # @return The given target to allow
    #     def project(id)
    #       project = Project.find(id)
    #       guard(:view, project)
    #     end
    #
    def guard(action, target, opts={})
      if guarded? && cannot?(action, target)
        raise Kindergarten::AccessDenied.new(action, target, opts) 
      end

      @guard_count += 1

      # to allow
      #   def project(id)
      #     project = Project.find(id)
      #     guard(:view, project)
      #   end
      #
      return target
    end

    # Increment the @guard_count without looking.
    #
    # When a block is given, set the Governess to unguarded during the 
    # execution of the block
    #
    def unguarded(&block)
      @guard_count += 1
      if block_given?
        @unguarded = true
        yield
        @unguarded = false
      end
    end

    def guarded?
      !unguarded?
    end

    def unguarded?
      !!@unguarded
    end
    
    # Scrub a hash of any key that is not specified
    #
    # @param [Hash] attributes An attributes-hash to scrub
    # @param [Symbol] list A list of allowed attributes
    #
    # @return [ScrubbedHash] a hash with only allowed keys
    def scrub(attributes, *list)
      list.map!(&:to_sym)
      
      Kindergarten::ScrubbedHash[
        attributes.symbolize_keys!.delete_if do |key,value|
          self.class.forbidden_keys.include?(key) || !list.include?(key)
        end
      ]
    end

    # Scrub a hash of any key that is not specified
    #
    # @param [Hash] attributes An attributes-hash to scrub
    # @param [Hash] untaint_opts Specify a Regexp for each key. The value from 
    #   the attributes will be matched against the regexp and replaced with 
    #   the first result.
    #
    #   specify :pass instead of a Regexp to let the value pass without 
    #   matching (usefull for non strings, etc.)
    #
    # @return [RinsedHash] a hash with only allowed keys and untainted values
    #
    # @example Untaint
    #   rinse(attributes, :name => /^([a-Z0-9]+)/, :description => /([\w\s-]+)/mg)
    #
    # @example Pass on a Date attribute
    #   rinse(attributes, :name => /([\w\s-]+)/, :date => :pass)
    #
    # @example Bad practice
    #   # beware of the dot-star!
    #   rinse(attributes, :name => /(.*)/)
    #
    def rinse(attributes, untaint_opts)
      untaint_opts.symbolize_keys!

      scrubbed = scrub(attributes, *untaint_opts.keys)

      scrubbed.each do |key, value|
        untaint = untaint_opts[key]
        next if untaint == :pass

        match = value.match(untaint)
        if match.nil?
          scrubbed.delete key
        else
          scrubbed[key] = match[1]
        end 
      end
      
      return Kindergarten::RinsedHash[scrubbed]
    end
  end
end
