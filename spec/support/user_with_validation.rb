# coding: utf-8

class UserWithValidation
  include Mongoid::Document

  field :phone, type: RussianPhone.field(default_country: 7, allowed_cities: [495]), validate: true
end