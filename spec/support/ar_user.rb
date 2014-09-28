class ArUser < ActiveRecord::Base
  russian_phone :phone

  russian_phone :validated_phone, default_country: 7, allowed_cities: [495], validate: true
end

