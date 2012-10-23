require 'kindergarten'

Dir[File.expand_path( "../support/**/*.rb", __FILE__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.tty = true
  # config.mock_with :mocha
end
