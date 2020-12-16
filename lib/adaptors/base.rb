# frozen_string_literal: true

require "json"
require "pathname"

module Adaptors
  class Base
    DB_DIR = File.expand_path("../../db/sources", Pathname.new(__FILE__).realpath)

    def initialize(file_name)
      @file_name = file_name
      fail ArgumentError, "No such file" unless File.exist? file_path
    end

    def data
      @data ||= JSON.parse(File.read(file_path))
    end

    def file_path
      [DB_DIR, @file_name].join("/")
    end

  end
end
