# frozen_string_literal: true

desc "Processes downloaded JSON"

task :process do
  puts "Processing"

  require "pry"
  require_relative "../config/db_connection"
  require_relative "../lib/models/line"
  require_relative "../lib/adaptors/base"
  require_relative "../lib/adaptors/lines"
  require_relative "../lib/adaptors/stations"

  stations_adaptor = Adaptors::Stations.new("data-en-2015-11-30.json")
  lines_adaptor    = Adaptors::Lines.new("data-en-2015-11-30.json")

  # stations_adaptor.data

  Line.delete_all

  lines_adaptor.cleaned_lines.each do |hash|
    Line.create!(
      name_ru: hash[:name_ru],
      name_en: hash[:name_en],
      uid:     hash[:uid]
    )
  end

end