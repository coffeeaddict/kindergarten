# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kindergarten/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hartog C. de Mik"]
  gem.email         = ["hartog@organisedminds.com"]
  gem.description   = %q{A kindergarten with a perimeter, a governess and a sandbox}
  gem.summary       = %q{Provide a kindergarten for your code to play in}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "kindergarten"
  gem.require_paths = ["lib"]
  gem.version       = Kindergarten::VERSION

  gem.add_dependency('cancan', ['~> 1.6.8'])
  gem.add_dependency('activesupport', ['> 3'])
  gem.add_dependency('rufus-json')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec', ['~> 2.11'])
  gem.add_development_dependency('activerecord', ['> 3'])
  gem.add_development_dependency('mysql2')
  gem.add_development_dependency('jdbc-mysql')
end
