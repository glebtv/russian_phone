module RussianPhone
  class Railtie < ::Rails::Railtie
    initializer 'russian_phone.active_record' do
      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send :include, RussianPhone::ActiveRecord
      end
    end
  end
end

