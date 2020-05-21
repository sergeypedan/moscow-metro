# frozen_string_literal: true

module MoscowMetro
  class RecordFromYaml

    def self.first
      all.first
    end

    def self.last
      all.last
    end

    private

    def self.hash_values(columns, hash)
      columns.map(&:to_s).map { |column_name| hash[column_name] }
    end

  end
end
