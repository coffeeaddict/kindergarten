require 'sqlite3'
require 'active_record'
require "kindergarten/orm/governess"

logger = Logger.new File.expand_path( "../support/log/test.log", __FILE__)
logger.formatter = proc { |severity, datetime, progname, msg|
  "[#{severity}] #{msg}\n"
}

ActiveRecord::Base.logger = logger
ActiveRecord::Base.establish_connection(
  :adapter   => 'sqlite3',
  :database  => File.expand_path( "../support/db/test.db", __FILE__),
)

