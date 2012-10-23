module RSpecWorldHelper
  def RWorld(constant)
    RSpec.configure do |config|
      config.include constant
    end
  end
end

include RSpecWorldHelper
