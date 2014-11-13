begin
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
          def type
            if property.type.class.name == "RussianPhone::Field"
              :string
            else
              type_without_russian_phone
            end
          end
        end
      end
    end
  end
rescue Exception => e 
end
