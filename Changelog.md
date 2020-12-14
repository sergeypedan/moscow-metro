# Changelog

### 0.1.9

- Added English names for lines where it was missing
- Added Russian prepositional names to lines

### 0.1.8

- Corrected Pry dependency in `bin/console`
- Added helpers to query lines belonging to metro sub-systems and stations at those lines:

	```ruby
	MoscowMetro::Station.at_mck #=> Array of stations
	MoscowMetro::Line.monorail  #=> Array of lines
	```
