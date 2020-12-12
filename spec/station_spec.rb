# frozen_string_literal: true

RSpec.describe MoscowMetro::Station do

	subject { described_class.all }

	it "There are no incorrect line UIDs in stations" do
		expect(subject.map(&:line_uid).uniq.sort).to eq MoscowMetro::Line.all.map(&:uid).sort
	end

	it "All stations have names" do
		expect(subject.select { |station| [nil, ""].include? station.name }).to eq []
	end

	it "All stations have name_en" do
		expect(subject.select { |station| [nil, ""].include? station.name_en }).to eq []
	end

	it "All stations have line UIDs" do
		expect(subject.select { |station| [nil, ""].include? station.line_uid }).to eq []
	end

	describe "`name_uniq` correcness" do
		let(:tally_results) { subject.map(&:name).tally }

		MoscowMetro::Station.all.each do |station|
			it ":name_uniq is #{station.name_uniq} for #{station.name}" do
				expect(station.name_uniq).to eq (tally_results.fetch(station.name) == 1)
			end
		end
	end

end