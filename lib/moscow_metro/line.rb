# frozen_string_literal: true

module MoscowMetro
	class Line < RecordFromYaml

		COLUMNS = [:color, :name, :name_en, :name_prepositional, :open_year, :uid]
		RECORDS = YAML.load_file(DB_DIR.join("lines.yml"))
		UIDS = {
			mcd:      %w[D1 D2 D3 D4 D5].freeze,
			mck:      %w[14].freeze,
			metro:    %w[1 2 3 4 5 6 7 8 8A 9 10 11 11A 12].freeze,
			monorail: %w[13].freeze
		}

		Record = Struct.new(*COLUMNS) do
			def stations
				MoscowMetro::Station.at_lines([uid])
			end
		end

		def self.all
			RECORDS.map { |record_data| Record.new(*hash_values(COLUMNS, record_data)) }
		end

		def self.find_by_uid(uid)
			all.find { |line| line.uid == uid }
		end

		def self.mcd
			all.select { |line| UIDS[:mck].include? line.uid }
		end

		def self.mck
			all.select { |line| UIDS[:mck].include? line.uid }
		end

		def self.metro
			all.select { |line| UIDS[:metro].include? line.uid }
		end

		def self.monorail
			all.select { |line| UIDS[:monorail].include? line.uid }
		end

	end
end
