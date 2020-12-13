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

	it "All stations have :latitude either Float or nil" do
		expect(subject.reject { |station| [NilClass, Float].include? station.latitude.class }).to eq []
	end

	it "All stations have :longitude either Float or nil" do
		expect(subject.reject { |station| [NilClass, Float].include? station.longitude.class }).to eq []
	end

	it "All stations have correct :name_uniq value" do
		tally_results = subject.map(&:name).tally
		stations_with_incorrect_name_uniq = MoscowMetro::Station.all.reject { |station| station.name_uniq == (tally_results.fetch(station.name) == 1) }
		expect(stations_with_incorrect_name_uniq).to eq []
	end

end
