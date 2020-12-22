# Changelog

### 0.2.0

- [Breaking] Now `station.coordinates` returns `nil` instead of `[]` if any of (or boath) coordinates miss
- Added a faster `MoscowMetro::Station.first` (compared to `MoscowMetro::Station.all.first`)
- Added a faster `MoscowMetro::Station.last` (compared to `MoscowMetro::Station.all.last`)

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
