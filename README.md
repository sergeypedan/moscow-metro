# MoscowMetro

[![Gem Version](https://badge.fury.io/rb/moscow_metro.svg)](https://badge.fury.io/rb/moscow_metro)
[![Build Status](https://travis-ci.org/sergeypedan/moscow-metro.svg?branch=master)](https://travis-ci.org/sergeypedan/moscow-metro)
[![Maintainability](https://api.codeclimate.com/v1/badges/379adc59603516bdbc8a/maintainability)](https://codeclimate.com/github/sergeypedan/moscow-metro/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/379adc59603516bdbc8a/test_coverage)](https://codeclimate.com/github/sergeypedan/moscow-metro/test_coverage)
[![Coverage Status](https://coveralls.io/repos/github/sergeypedan/moscow-metro/badge.svg?branch=master)](https://coveralls.io/github/sergeypedan/moscow-metro?branch=master)

Список станций и линий Московского метрополитена + хелперы.

### Актуальность данных

Дата последней проверки: 1 июля 2020 г.

Если гем отстал от жизни, можно написать мне в Telegram (`sergey_pedan`) или прислать PR (и лучше написать об этом в Tg).

### Только метро?

Есть линии и странции из:

- Метрополитена
- Большой кольцевой линии метро
- Монорельса
- Московского центрального кольца (МЦК)
- Московских центральных диаметров

### Уникальность названий

Названия станций не уникальны: есть Белорусская кольцевой и Замоскворецкой линии.

Возможно, выводя название станций на страницу (например, в `<select>` или в блоке адреса), вам захочется писать название линии рядом с теми станциями, которые называются одинаково, и не указывать для станций с уникальным именем. Например, «Белорусская кольцевая», но «Новокузнецкая».

Для этих целей у станций есть свойство `name_uniq` (boolean):

```ruby
ul
  - stations.each do |station|
    li
      = station.name
      =< "(#{station.line.name})" unless station.name_uniq
```

```html
<ul>
  <li>Автозаводская (Замоскворецкая)</li>
  <li>Автозаводская (МЦК)</li>
  <li>Академическая</li> <!-- Академическая только на 1 линии -->
</ul>
```

### UID линий

Московский метрополитен использует некие UID для линий, мы берём его, а не придумываем свои ID. Для большинства линий это Integer, но встречаются линии с UID, состоящим из Integer и строки, как `11A`, поэтому все UID хранятся как String.

### UID станций

У станций пока нет UID, добавлю в ближайшем будущем.

### Корректность данных

Тесты гарантируют, что:

- у всех линий заполнен `name`
- у всех линий заполнен `name_en`
- у всех линий заполнен `name_prepositional` (название в предложном падеже)
- у всех линий заполнен `color`
- у всех линий заполнен `uid`
- у всех станций заполнен `name`
- у всех станций заполнен `name_en`
- у всех станций заполнен `color`
- у всех станций заполнен `line_uid`
- у всех станций заполнен `name_uniq` + его корректность
- у всех станции `line_uid` указывает на какую-то конкретную линию


## Installation

```ruby
gem "moscow_metro"
```

## Play / debug

```sh
gem install moscow_metro
cd $(bundle info moscow_metro --path) # open the folder where the gem was installed
bin/console                           # load the gem and Pry
```

now all gem methods are accessible:

```ruby
MoscowMetro::Station.all
```

## Usage

Предполагается 3 варианта использования этого джема:

### 1. Использовать данные напрямую из gem

Использовать gem в качестве источника данных, не создавая таблиц в своей БД.

Для данных о станциях и линиях есть ActiveRecord-подобные классы с методами поиска:

```ruby
MoscowMetro::Station.all #=> Array of stations

MoscowMetro::Station.at_mcd      #=> Array of stations
MoscowMetro::Station.at_mck      #=> Array of stations
MoscowMetro::Station.at_metro    #=> Array of stations
MoscowMetro::Station.at_monorail #=> Array of stations
```

```ruby
MoscowMetro::Line.all    #=> Array of lines

MoscowMetro::Line.find_by_uid("11A") #=> #<struct MoscowMetro::Line::Record...>
MoscowMetro::Line.find_by_uid("404") #=> nil

MoscowMetro::Line.mcd      #=> Array of lines
MoscowMetro::Line.mck      #=> Array of lines
MoscowMetro::Line.metro    #=> Array of lines
MoscowMetro::Line.monorail #=> Array of lines
```

и attribute-readers у экземпляров:

```ruby
line = MoscowMetro::Line.all.first #=> #<struct MoscowMetro::Line::Record...>
line.color               #=> "#f91f22"
line.name                #=> "Сокольническая"
line.name_en             #=> "Сокольническая"
line.name_prepositional  #=> "Сокольнической"
line.uid                 #=> "1"
```

```ruby
station = MoscowMetro::Station.first #=> #<struct MoscowMetro::Station::Record...>
station.coordinates #=> [37.7191, 55.7524] || nil
station.latitude    #=> 37.7191 || nil
station.longitude   #=> 55.7524 || nil
station.line_uid    #=> "8"
station.name        #=> "Авиамоторная"
station.name_en     #=> "Aviamotornaya" || nil
station.name_uniq   #=> false || true
```

и ассоциации:

```ruby
station = MoscowMetro::Station.first #=> #<struct MoscowMetro::Station::Record...>
station.line  #=> #<struct MoscowMetro::Line::Record ...>
```

```ruby
line = MoscowMetro::Line.all.first #=> #<struct MoscowMetro::Line::Record...>
line.stations  #=> Array
```

### 2. Хранить станции и линии в БД, а gem использовать для валидаций

Это имеет смысл, если вы решите хранить станции и линии в БД, но не хотите хранить все существующие станции. Тогда при создании новой станции будет полезно проверять корректность имени.

Например, так:

```ruby
# models/metro/station.rb
class Metro::Station < ActiveRecord::Base
  validates :name, inclusion: { in: MoscowMetro::Station.names }
end
```

### 3. Для первичного «посева» станций в БД

Вы хотите хранить станции и линии в БД, и вам нужно просто их туда откуда-то записать.

```ruby
MoscowMetro::Station.all.each do |station|
  ::Station.create!({ name_ru: station.name, name_en: station.name_en, ... })
end
```

Также можно использовать данные прямо из YAML-файлов:

- [stations.yml](https://github.com/sergeypedan/moscow-metro/blob/master/lib/db/stations.yml)
- [lines.yml](https://github.com/sergeypedan/moscow-metro/blob/master/lib/db/lines.yml)


## Источники данных

- https://data.mos.ru/classifier/7704786030-stantsii-moskovskogo-metropolitena
- https://data.gov.ru/opendata/7704786030-moscowsubwaystations
- https://stroi.mos.ru/metro
- https://transport.mos.ru
- https://transport.mos.ru/metro/map
- http://mcd.mosmetro.ru/map/desktop/
- https://mosmetro.ru/metro-map/
- https://www.mos.ru/city/projects/diametry/
- https://en.wikipedia.org/wiki/Moscow_Metro
- https://en.wikipedia.org/wiki/List_of_Moscow_Metro_stations

На сайте mosmetro.ru есть удобный `<select>`, из которого можно скачать данные:

```js
window.location.href = "http://mcd.mosmetro.ru/map/desktop/"

let divs = Array.from(document.getElementsByClassName("fromto__select-list-item"))

divs.length // 672

function station_object_from_div(div) {
  let ids = div.dataset.id.replace("line", "").split("_")
  return {
       color: div.dataset.color,
    line_uid: ids[0],
        name: div.innerText,
         uid: ids[1]
  }
}

let station_objects = divs.map(div => station_object_from_div(div))

console.table(station_objects)
```

Получаем таблицу наподобие этой:

 color   | name                | line_uid | uid
:--------|:--------------------|:---------|:----
 #FFCD1E | Авиамоторная        | 8        | 5
 #d68ab1 | Авиамоторная        | 15       | 1
 #4baf4f | Автозаводская       | 2        | 15
 #ffcec6 | Автозаводская       | 14       | 11
 #ef7e24 | Академическая       | 6        | 16
 #24bcee | Александровский сад | 4        | 1
 #ef7e24 | Алексеевская        | 6        | 6
 #4baf4f | Алма-Атинская       | 2        | 24
 #adacac | Алтуфьево           | 9        | 1

Жалко только, в названиях они не ставят букву «ё».


## Roadmap

- UIDs для станций
- предложный падеж для линий («на Кольцевой», «на Сокольнической»)
- предложный падеж для станций («на Охотном ряду», «на Университете», «на Ленинском проспекте»)
- работает ли станция
- работает ли линия
- автоматизировать проверку актуальности информации от каких-нибудь более-менее официальных источников
