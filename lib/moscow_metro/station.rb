# frozen_string_literal: true

module MoscowMetro
	class Station < RecordFromYaml

		COLUMNS = [:coordinates, :latitude, :longitude, :name, :name_en, :name_uniq, :line_uid]
		RECORDS = YAML.load_file(DB_DIR.join("stations.yml"))

		Record = Struct.new(*COLUMNS) do
			def coordinates
				[latitude, longitude] if (latitude && longitude)
			end

			def line
				MoscowMetro::Line.find_by_uid(line_uid)
			end
		end

		class << self

			def all
				RECORDS.map { |record_data| to_record(record_data) }
			end

			def first
				to_record RECORDS.first
			end

			def last
				to_record RECORDS.last
			end

			def to_record(record_data)
				Record.new(*hash_values(COLUMNS, record_data))
			end

			def names
				all.map(&:name).uniq
			end

			def at_lines(uids)
				all.select { |station| uids.include? station.line_uid }
			end

			def at_mcd
				at_lines Line::UIDS[:mck]
			end

			def at_mck
				at_lines Line::UIDS[:mck]
			end

			def at_metro
				at_lines Line::UIDS[:metro]
			end

			def at_monorail
				at_lines Line::UIDS[:monorail]
			end

		end
	end
end
