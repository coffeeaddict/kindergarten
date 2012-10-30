require 'rufus-json/automatic'

module Kindergarten
  class Event
    attr_reader :name, :purpose, :payload

    def self.load(hash)
      if hash.is_a?(String)
        hash = begin
          Rufus::Json.decode(hash)
        rescue => ex
          raise ArgumentError.new("The provided string could not be decoded as JSON")
        end
      end

      hash.symbolize_keys!
      self.new(hash[:name], hash[:purpose], hash[:payload])
    end

    def initialize(name, purpose, payload)
      @name    = name    || raise("An event must have a name")
      @purpose = purpose || raise("An event must have a purpose")
      @payload = payload
    end

    def to_json
      Rufus::Json.encode(name: @name, purpose: @purpose, payload: @payload)
    end
  end
end
