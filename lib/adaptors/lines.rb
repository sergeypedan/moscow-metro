# frozen_string_literal: true

require_relative "base"

module Adaptors

  class Lines < Adaptors::Base

    KNOWN_LINES = [
      ["Арбатско-Покровская", "3"],
      ["Белорусско-Савёловский диаметр", "D1"],
      ["Большая кольцевая", "11"],
      ["Третий Пересадочный контур", "11"],
      ["Бутовская", "12"],
      ["Замоскворецкая", "2"],
      ["Калининская", "8"],
      ["Калужско-Рижская", "6"],
      ["Калужско-Рижский диаметр", "D2"],
      ["Каховская", "11A"],
      ["Кожуховская", "15"],
      ["Кольцевая", "5"],
      ["Люблинско-Дмитровская", "10"],
      ["Монорельс", "13"],
      ["Московское центральное кольцо", "14"],
      ["МЦК", "14"],
      ["Некрасовская", "15"],
      ["Серпуховско-Тимирязевская", "9"],
      ["Сокольническая", "1"],
      ["Солнцевская", "8A"],
      ["Таганско-Краснопресненская", "7"],
      ["Филёвская", "4"]
    ].freeze

    def cleaned_lines
      uniq_lines.map { |line|
        name_ru = cleanup_line_name(line[:name_ru])
        {
          name_ru: name_ru,
          name_en: cleanup_line_name(line[:name_en]),
          uid:     find_uid_by_name_ru(name_ru)
        }
      }
    end

    def find_uid_by_name_ru(name_ru)
      line_array = KNOWN_LINES.find { |name, uid| name_ru.downcase.include? name.downcase }
      fail StandardError, "Cannot find line for «#{name_ru}»" unless line_array
      line_array[1]
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
