# RussianPhone

[![Build Status](https://travis-ci.org/glebtv/russian_phone.svg?branch=master)](https://travis-ci.org/glebtv/russian_phone)
[![Dependency Status](https://gemnasium.com/glebtv/russian_phone.svg)](https://gemnasium.com/glebtv/russian_phone)

## Что это

Гем для разбора и нормализации русских телефонных номеров.

Основной упор сделан на разбор абсолютно любого формата номера (+7-495, 8(495), без кода страны или города (с ошибкой или подстановкой региона по умолчанию и т.д.).

Предназначен как замена маске ввода (которая является ужасным по юзабилити и глючным решением)

Если вы знаете формат, который пользователь реалистично может ввести - а гем его не разбирает - [сообщите об этом](https://github.com/glebtv/russian_phone/issues/new)

Поддерживаемые форматы можно найти в [тестах](https://github.com/glebtv/russian_phone/blob/master/spec/phone_spec.rb#L255)

Разработка -  glebtv и [Rocket Scicence](https://github.com/rs-pro)

## Альтернативные решения

https://github.com/floere/phony

https://github.com/joost/phony_rails

https://github.com/carr/phone

https://github.com/sstephenson/global_phone

Указанные решения поддерживают несколько стран

russian_phone поддерживает и будет поддерживать только российские телефонные номера

Целью данного гема было скорее получение номера в чистом виде (10 значного) из введенных пользователем данных, и
возможный минимум отбраковки верных номеров, которые сможет разобрать человек, чем 100% отбраковка неверных номеров.

## Installation

Add this line to your application's Gemfile:

    gem 'russian_phone'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install russian_phone

## Usage

Использованиие для разбора телефонных номеров:

    # phone = RussianPhone::Number.new('(906) 111-11-11', default_country: 7)
    => "+7 (906) 111-11-11"
    # phone.country
    => "7"
    # phone.city
    => "906"
    # phone.subscriber
    => "1111111"
    # phone.formatted_subscriber
    => "111-11-11"
    # phone.full
    => "+7 (906) 111-11-11"
    # phone.clean
    => "79061111111"
    # phone.cell?
    => true
    # phone.free?
    => false
    # phone.valid?
    => true

Использование с Mongoid:

    class User
        include Mongoid::Document
        field :phone, type: RussianPhone.field(default_country: 7, allowed_cities: [495]), validate: true, required: true
    end

    # u = User.new(phone: '495 1111111')
    # u.phone
    => '+7 (495) 111-11-11'
    # u.phone.valid?
    => true

Использование с ActiveRecord

    class ArUser < ActiveRecord::Base
      russian_phone :phone
      russian_phone :validated_phone, default_country: 7, allowed_cities: [495], validate: true
    end

    # u = ArUser.new(phone: '495 1111111')
    # u.phone
    => '+7 (495) 111-11-11'
    # u.phone.valid?
    => true


Обратите внимание, по умолчанию *валидация телефонного номера выключена*, это значит что номер будет
сохраняться в базу даже если гем не смог его разобрать. Включите валидацию, установив validate:true.

В базе телефоны храняться в виде строки в полном виде, если телефон удалось разобрать, и в том виде как
введено пользователем, если не удалось разобрать и validate == false

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
