# frozen_string_literal: true

module MoscowMetro
  class Station < RecordFromYaml

    COLUMNS = [:name, :name_uniq, :line_uid]
    RECORDS = YAML.load_file(DB_DIR.join("stations.yml"))

    Record = Struct.new(*COLUMNS) do
      def line
        MoscowMetro::Line.find_by_uid(line_uid)
      end
    end

    def self.all
      RECORDS.map { |record_data| Record.new(*hash_values(COLUMNS, record_data)) }
    end

    def self.names
      all.map(&:name).uniq
    end

  end
end
