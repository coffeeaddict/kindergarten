module Kindergarten
  # A Perimeter is used to define the places where the child can play.
  #
  # @example
  #   class ExamplePerimeter < Kindergarten::Perimeter
  #     purpose :books
  #
  #     govern do |child|
  #       can :read, Book do |book|
  #         book.level <= 2
  #       end
  #     end
  #
  #     def read(book)
  #       guard(:read, book)
  #       book.read
  #     end
  #
  #     sandbox :read
  #   end
  #
  class Perimeter
    class << self
      attr_reader :sandboxed_methods, :govern_proc

      # Define a list of sandbox methods
      def sandbox(*list)
        @sandboxed_methods ||= []
        @sandboxed_methods |= list
      end

      # Instruct the Governess how to govern this perimeter
      def govern(&proc)
        @govern_proc = proc
      end

      # Get/set the purpose of the perimeter
      def purpose(*purpose)
        purpose.any? ? @purpose = purpose[0] : @purpose
      end

      # Get/set the governess of the perimeter
      def governess(*klass)
        klass.any? ? @governess = klass[0] : @governess
      end

      # Subscribe to an event from a given purpose
      # @param [Symbol] purpose Listen to other perimeters that have this
      #   purpose
      # @param [Symbol] event Listen for events with this name
      # @param [Proc,Symbol] block Invoke this on the event
      # @example Symbol form
      #   subscribe :users, :create, :user_created
      #
      #   def user_created(event)
      #     # ...
      #   end
      #
      # @example Block form
      #   subscribe :users, :update do |event|
      #     # ...
      #   end
      #
      def subscribe(purpose, event, block)
        @callbacks ||= {}
        @callbacks[purpose] ||= {}
        @callbacks[purpose][event] ||= []
        @callbacks[purpose][event] << block
      end
    end

    attr_reader :child, :governess

    # Obtain an un-sandboxed instance for testing purposes
    #
    # @return [Perimeter] with the given child and/or governess
    #
    def self.instance(child=nil, governess=nil)
      self.new(child, governess)
    end

    def initialize(child, governess)
      @child     = child
      @governess = governess

      unless @governess.nil? || self.class.govern_proc.nil?
        @governess.instance_eval(&self.class.govern_proc)
      end
    end

    # @return [Array] List of sandbox methods
    def sandbox_methods
      self.class.sandboxed_methods
    end

    # @see Governess#scrub
    def scrub(*args)
      self.governess.scrub(*args)
    end

    # @see Governess#rinse
    def rinse(*args)
      self.governess.rinse(*args)
    end

    # @see Governess#guard
    def guard(action, target)
      self.governess.guard(action, target)
    end

    # @see Governess#unguarded
    def unguarded(&block)
      self.governess.unguarded(&block)
    end

    def governed(method, unguarded=false, &block)
      if unguarded == true
        self.governess.unguarded do
          self.governess.governed(method, &block)
        end

      else
        self.governess.governed(method, &block)

      end
    end

  end
end
