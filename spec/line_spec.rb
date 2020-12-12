# frozen_string_literal: true

RSpec.describe MoscowMetro::Line do

	subject { described_class.all }

	it "All lines have names" do
		expect(subject.select { |station| [nil, ""].include? station.name }).to eq []
	end

	it "All lines have color" do
		expect(subject.select { |station| [nil, ""].include? station.color }).to eq []
	end

	it "All lines have UIDs" do
		expect(subject.select { |station| [nil, ""].include? station.uid }).to eq []
	end

end
