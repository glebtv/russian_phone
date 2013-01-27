# coding: utf-8

module RussianPhone
  module Mongoid
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      def phone_field( *columns )
        opts = columns.last.is_a?( Hash ) ? columns.pop : {}
        opts = {
            allowed_codes: [],
            default: nil,
            required: false,
            default_code: nil
        }.merge(opts)

        [columns].flatten.each do |name|
          name = name.to_s
          field name, type: RussianPhone::Number

          if opts[:required]
            validates_presence_of name
          end

          define_method(name) do
            RussianPhone::Number.new(read_attribute(name), default_code: opts[:default_code])
          end

          define_method("#{name}=") do |value|
            write_attribute(name, RussianPhone::Number.new(value))
          end
        end
      end
    end
  end
end
