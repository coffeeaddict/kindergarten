module Kindergarten
  # A very easy governess, lets everything happen unguarded. Perhaps not such
  # a good idea to be using this...
  #
  class EasyGoverness < HeadGoverness
    def initialize(child)
      super
      @unguarded = true
    end
  end
end