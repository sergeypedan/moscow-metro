# frozen_string_literal: true

require_relative "base"

module Adaptors

  class Stations < Adaptors::Base

    def to_attributes(hash)
      res = {}
      res[:id]        = hash["ID"]
      res[:id_global] = hash["global_id"]
      res[:name]      = cleanup_line_name(hash["Station"])
      res[:name_en]   = cleanup_line_name(hash["Station_en"])
      res[:name_uniq] = nil
      res[:status]    = hash["Status"]

      res[:line_uid]  = find_line(hash["Line"])

      res
    end

    def to_attributes_all
      data.map { |hash| to_attributes(hash) }
    end

    private def find_line(dirty_line_name)
      # cleanup_line_name(dirty_line_name)
    end

  end
end
