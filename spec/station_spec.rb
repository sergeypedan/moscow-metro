# frozen_string_literal: true

RSpec.describe MoscowMetro::Station do

	describe ".all" do
		subject { described_class.all }

		it { is_expected.to be_a Array }

		it "Consists only of #{described_class::Record}" do
			expect(subject.all? described_class::Record).to eq true
		end
	end

	describe ".first" do
		subject { described_class.first }
		it { is_expected.to be_a described_class::Record }
	end

	describe ".last" do
		subject { described_class.last }
		it { is_expected.to be_a described_class::Record }
	end

  describe ".at_mcd" do
    subject { described_class.at_mcd }
    it { is_expected.to be_a Array }
  end

  describe ".at_mck" do
    subject { described_class.at_mck }
    it { is_expected.to be_a Array }
  end

  describe ".at_metro" do
    subject { described_class.at_metro }
    it { is_expected.to be_a Array }
  end

  describe ".at_monorail" do
    subject { described_class.at_monorail }
    it { is_expected.to be_a Array }
  end

	describe "All stations have…" do
		subject { described_class.all }

		it "correct line UIDs" do
			expect(subject.map(&:line_uid).uniq.sort).to eq MoscowMetro::Line.all.map(&:uid).sort
		end

		it "names" do
			expect(subject.select { |station| [nil, ""].include? station.name }).to eq []
		end

		it "name_en" do
			expect(subject.select { |station| [nil, ""].include? station.name_en }).to eq []
		end

		it "line UIDs" do
			expect(subject.select { |station| [nil, ""].include? station.line_uid }).to eq []
		end

		it ":latitude either Float or nil" do
			expect(subject.reject { |station| [NilClass, Float].include? station.latitude.class }).to eq []
		end

		it ":longitude either Float or nil" do
			expect(subject.reject { |station| [NilClass, Float].include? station.longitude.class }).to eq []
		end

		it "correct :name_uniq value" do
			tally_results = subject.map(&:name).tally
			stations_with_incorrect_name_uniq = subject.reject { |station| station.name_uniq == (tally_results.fetch(station.name) == 1) }
			expect(stations_with_incorrect_name_uniq).to eq []
		end
	end

  describe "#line" do
    subject { described_class.all.sample.line }
    it { is_expected.to be_a MoscowMetro::Line::Record }
  end

  describe "#coordinates" do
    context "has both coordinates" do
      let(:station) { described_class.all.find { |st| [st.latitude, st.longitude].all? Float } }
      subject { station.coordinates }
      it { is_expected.to eq [station.latitude, station.longitude] }
    end

    context "has no coordinates" do
      subject { described_class.all.find { |st| [st.latitude, st.longitude].all? NilClass }.coordinates }
      it { is_expected.to be_nil }
    end

  end

end
