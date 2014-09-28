# coding: utf-8

class UserWithoutValidation
  include Mongoid::Document

  field :phone, type: RussianPhone.field(default_country: 7, allowed_cities: [495])
end
