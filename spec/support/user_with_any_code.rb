# coding: utf-8

class UserWithAnyCode
  include Mongoid::Document

  field :phone, type: RussianPhone.field(default_country: 7), validate: true
end