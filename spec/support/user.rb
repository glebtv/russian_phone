# coding: utf-8

class User
  include Mongoid::Document

  field :name

  field :phone, type: RussianPhone::Field, default_country: 7
end