adapter = RUBY_PLATFORM == 'java' ? 'jdbc-mysql' : 'mysql2'
require adapter

require 'active_record'
require "kindergarten/orm/governess"

logger = Logger.new File.expand_path( "../support/log/test.log", __FILE__)
logger.formatter = proc { |severity, datetime, progname, msg|
  "[#{severity}] #{msg}\n"
}

ActiveRecord::Base.logger = logger
ActiveRecord::Base.establish_connection(
  :adapter   => adapter,
  :database  => 'kindergarten_test',
  :username  => 'root',
  :encoding  => 'utf8'
)
