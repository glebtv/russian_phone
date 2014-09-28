module RussianPhone
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def russian_phone(field, *args)
        name = field.to_s

        options = args.extract_options! || {}
        instance_variable_set "@#{name}_phone_options", options

        if options[:validate]
          validates_with(RussianPhone::FormatValidator, fields: [name])
        end

        if options[:required]
          validates_with(RussianPhone::PresenceValidator, fields: [name])
        end

        define_method name do
          options = self.class.instance_variable_get("@#{name}_phone_options")
          RussianPhone::Number.new(read_attribute(name), options)
        end
        define_method "#{name}=" do |value|
          instance_variable_set("@#{name}_phone_before_type_cast", value)
          options = self.class.instance_variable_get("@#{name}_phone_options")
          self[name] = RussianPhone::Number.new(value, options).mongoize
        end
        define_method "#{name}_phone_before_type_cast" do
          instance_variable_get "@#{name}_phone_before_type_cast"
        end
        after_save do
          instance_variable_set "@#{name}_phone_before_type_cast", nil
        end
      end
    end
  end
end
