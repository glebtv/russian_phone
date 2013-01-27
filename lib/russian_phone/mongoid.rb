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
            default_country: 7,
            default_city: nil
        }.merge(opts)


        [columns].flatten.each do |name|
          name = name.to_s
          field_opts = opts.dup
          field_opts[:type] = RussianPhone::Field
          field name, field_opts

          #
          #if opts[:required]
          #  validates_presence_of name
          #end
          #
          #define_method(name) do
          #  RussianPhone::Field.new(read_attribute(name), opts)
          #end
          #
          #define_method("#{name}=") do |value|
          #  write_attribute(name, RussianPhone::Field.new(value, opts))
          #end
        end
      end
    end
  end
end
