# frozen_string_literal: true

require_relative "base"

module Adaptors

  class Lines < Adaptors::Base

    def cleaned_lines
      uniq_lines.map { |line|
        { name_ru: cleanup_line_name(line[:name_ru]), name_en: cleanup_line_name(line[:name_en]) }
      }
    end

    def uniq_lines
      non_uniq_lines.uniq
    end

    def non_uniq_lines
      @non_uniq_lines = data.map { |hash|
        { name_ru: hash["Line"], name_en: hash["Line_en"] }
      }
    end

    private def cleanup_line_name(name)
      name.sub(" линия Лёгкого метро", "")
          .sub(" liniya Lyogkogo metro", "")
          .sub(/ линия$/, "")
          .sub(/ liniya$/, "")
          .sub("Московская монорельсовая транспортная система", "Монорельс")
          .sub("Moskovskaya monorel'sovaya transportnaya sistema", "Monorail")
    end

  end
end
