# coding: utf-8

module RussianPhone
  class PresenceValidator < ActiveModel::Validator
    def validate(record)
      options[:fields].each do |field|
        if record.send(field).phone.blank?
          record.errors[field] << 'Необходимо заполнить'
        end
      end
    end
  end
end
