require 'rails_admin/adapters/mongoid'
begin
  require 'rails_admin/adapters/mongoid/property'
rescue Exception => e 
end

module RailsAdmin
  module Adapters
    module Mongoid
      class Property
        alias_method :type_without_russian_phone, :type
        def type(name, field)
          if field.type.class.name == "RussianPhone::Field"
            { :type => :string }
          else
            type_without_russian_phone(name, field)
          end
        end
      end
    end
  end
end

