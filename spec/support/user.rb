# coding: utf-8

class User
  include Mongoid::Document
  include RussianPhone::Mongoid

  field :name

  phone_field :phone
end