# coding: utf-8

require "russian_phone/version"

module RussianPhone
  autoload :Field,             'russian_phone/field'
  autoload :Number,            'russian_phone/number'
  autoload :Codes,             'russian_phone/codes'
  autoload :PresenceValidator, 'russian_phone/presence_validator'
  autoload :FormatValidator,   'russian_phone/format_validator'

  def self.field(options = {})
    RussianPhone::Field.new(options)
  end
end

if Object.const_defined?("RailsAdmin")
  require 'rails_admin/adapters/mongoid'
  require 'rails_admin/config/fields/types/text'
  module RailsAdmin
    module Adapters
      module Mongoid
        alias_method :type_lookup_without_russian_phone, :type_lookup
        def type_lookup(name, field)
          if field.type.class.name == "RussianPhone::Field"
            { :type => :string }
          else
            type_lookup_without_russian_phone(name, field)
          end
        end
      end
    end
  end
end
