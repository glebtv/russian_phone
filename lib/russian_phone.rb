# coding: utf-8

require "russian_phone/version"

module RussianPhone
  autoload :Field,        'russian_phone/field'
  autoload :Number,       'russian_phone/number'
  autoload :Codes,        'russian_phone/codes'

  def self.field(options = {})
    RussianPhone::Field.new(options)
  end
end
