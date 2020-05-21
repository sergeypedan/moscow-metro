require "pathname"
require "yaml"

require_relative "moscow_metro/version"
require_relative "moscow_metro/record_from_yaml"

module MoscowMetro

  class Error < StandardError; end

  DB_DIR = Pathname.new(File.expand_path("../db", __FILE__))

end

require_relative "moscow_metro/line"
require_relative "moscow_metro/station"
