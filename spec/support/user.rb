# coding: utf-8

class User
  include Mongoid::Document

  field :name

  field :phone, type: RussianPhone::Number, default_country: 7, allowed_cities: [495]

  field :phone_in_495, type: RussianPhone::Number, default_country: 7, default_city: '495'
  field :phone_in_812, type: RussianPhone::Number, default_country: 7, default_city: '812'
end