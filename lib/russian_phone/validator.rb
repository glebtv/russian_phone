# coding: utf-8

module RussianPhone
  class Validator < ActiveModel::Validator
    def validate(record)
      options[:fields].each do |field|
        unless record.send(field).blank?
          record.errors[field] << 'Неверный телефонный номер' unless record.send(field).valid? && record.send(field).city_allowed?
        end
      end
    end
  end
end
