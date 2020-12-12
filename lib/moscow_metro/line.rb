# frozen_string_literal: true

module MoscowMetro
  class Line < RecordFromYaml

    COLUMNS = [:color, :name, :open_year, :uid]
    RECORDS = YAML.load_file(DB_DIR.join("lines.yml"))
    Record  = Struct.new(*COLUMNS)

    def self.all
      RECORDS.map { |record_data| Record.new(*hash_values(COLUMNS, record_data)) }
    end

    def self.find_by_uid(uid)
      all.find { |line| line.uid == uid }
    end

  end
end
