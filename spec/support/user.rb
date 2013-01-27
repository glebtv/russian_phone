# coding: utf-8

class User
  include Mongoid::Document

  field :name

  field :phone, type: RussianPhone::Number, default_country: 7, allowed_codes: [495]
end