source 'https://rubygems.org'

# for travis, use a real gemfile
gem "cancan", "~> 1.6.8"
gem "activesupport", "> 3"

group :development do
  gem "bundler", "~> 1.2"
  gem "rake"
  gem "rspec", '~> 2.11'
  gem "activerecord", "> 3"
  platforms :jruby do
    gem 'jdbc-mysql'
    gem 'activerecord-jdbcmysql-adapter'
  end
  platforms :ruby do
    gem 'mysql2', :git => "git://github.com/brianmario/mysql2.git"
 end
end
