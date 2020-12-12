# MoscowMetro

Список станций и линий Московского метрополитена + хелперы.

### Актуальность данных

Дата последней проверки: 1 июля 2020 г.

### Уникальность названий

Названия станций не уникальны: есть Белорусская кольцевой и Замоскворецкой линии.

Возможно, выводя название станций на страницу (например, в `<select>` или в блоке адреса), вам захочется писать название линии рядом с теми станциями, которые называются одинаково, и не указывать для станций с уникальным именем. Например, «Белорусская кольцевая», но «Новокузнецкая».

Для этих целей у станций есть свойство `name_uniq`.

### UID линий

Московский метрополитен использует некие UID для линий, мы берём его, а не придумываем свои ID. Для большинства линий это Integer, но встречаются линии с UID, состоящим из Integer и строки, как `11A`, поэтому все UID мы храним как String.

### Корректность данных

Тесты гарантируют, что:

- у всех станций есть `name`
- у всех станций есть `color`
- у всех станций есть `line_uid`
- у всех станций корректно заполнен `name_uniq`
- у всех станции `line_uid` указывает на какую-то конкретную линию
- у всех линий есть `name`
- у всех линий есть `color`
- у всех линий есть `uid`

## Installation

```ruby
gem "moscow_metro"
```

## Usage

Предполагается 3 варианта использования этого джема:

1. Использовать gem в качестве базы данных, не создавая таблиц в своей БД. Если gem отстанет от жизни, можно форкнуть или прислать PR.
1. Хранить станции и линии в БД, а gem использовать для валидаций.
1. Хранить станции и линии в БД. Gem поможет создать классы и миграции + автоматически заполнить таблицы, запустив Rake task.


### 1. Использовать gem в качестве базы данных

Для данных о станциях и линиях есть ActiveModel-подобные классы с методами поиска:

```ruby
MoscowMetro::Station.all #=> Array
MoscowMetro::Line.all    #=> Array
MoscowMetro::Line.find_by_uid("11A") #=> <MoscowMetro::Line>
MoscowMetro::Line.find_by_uid("404") #=> nil
```

и attribute-readers у экземпляров:

```ruby
line = MoscowMetro::Line.all.first #=> #<struct MoscowMetro::Line::Record name="Сокольническая", color="#f91f22", uid="1">
line.color #=> "#f91f22"
line.name  #=> "Сокольническая"
line.uid   #=> "1"
```

## Источники данных

- https://transport.mos.ru
- https://transport.mos.ru/metro/map
- http://mcd.mosmetro.ru/map/desktop/
- https://www.mos.ru/city/projects/diametry/
- https://en.wikipedia.org/wiki/Moscow_Metro
- https://en.wikipedia.org/wiki/List_of_Moscow_Metro_stations

### Получаем инфомацию из раскрывающегося списка метро

```js
window.location.href = "http://mcd.mosmetro.ru/map/desktop/"

let divs = Array.from(document.getElementsByClassName("fromto__select-list-item"))

divs.length // 672

function station_object_from_div(div) {
  let ids = div.dataset.id.replace("line", "").split("_")
  return {
  	color:    div.dataset.color,
  	line_uid: ids[0],
  	name:     div.innerText,
  	uid:      ids[1]
  }
}

let station_objects = divs.map(div => station_object_from_div(div))

console.table(station_objects)
```

Получаем таблицу врое этой:

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
