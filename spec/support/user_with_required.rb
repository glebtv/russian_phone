# coding: utf-8

class UserWithRequired
  include Mongoid::Document

  field :phone, type: RussianPhone.field(default_country: 7, allowed_cities: [495]), validate: false, required: true
end