# frozen_string_literal: true

require "active_record"
require "logger"
require "pg"

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  database: 'metro',
  host:     'localhost',
  password: '',
  username: 'sergey'
)
