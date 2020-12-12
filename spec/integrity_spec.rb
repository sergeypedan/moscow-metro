# frozen_string_literal: true

RSpec.describe MoscowMetro do

	describe "Line UIDs" do
		it "There are no incorrect line UIDs in stations" do
			expect(MoscowMetro::Station.all.map(&:line_uid).uniq.sort).to eq MoscowMetro::Line.all.map(&:uid).sort
		end
	end

	describe "`name_uniq` correcness" do
		let(:tally_results) { MoscowMetro::Station.all.map(&:name).tally }

		MoscowMetro::Station.all.each do |station|
			it ":name_uniq is #{station.name_uniq} for #{station.name}" do
				expect(station.name_uniq).to eq (tally_results.fetch(station.name) == 1)
			end
		end
	end

end
