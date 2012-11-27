require 'kindergarten'
require 'mocha_standalone'

Dir[File.expand_path( "../support/**/*.rb", __FILE__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.tty = true
  config.mock_with :mocha
  config.before(:suite) do
    # During the suite, let there be no warnings
    Kindergarten.warnings = false
  end
end
