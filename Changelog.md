# Changelog

### 0.1.8

- Corrected Pry dependency in `bin/console`
- Added helpers to query lines belonging to metro sub-systems and stations at those lines:

	```ruby
	MoscowMetro::Station.at_mck #=> Array of stations
	MoscowMetro::Line.monorail  #=> Array of lines
	```
