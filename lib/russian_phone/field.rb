# coding: utf-8

module RussianPhone
  class Field
    attr_accessor :phone

    def initialize(phone, opts = {})
      p opts
      p self
      @phone = RussianPhone::Number.parse(phone, opts)
    end

    ::Mongoid::Fields.option :allowed_codes do |model, field, value|
      #p model, field, value
      #model.send(field).allowed_codes = value
    end
    ::Mongoid::Fields.option :default_country do |model, field, value|
      # model.send(field).default_country = value
    end
    ::Mongoid::Fields.option :default_city do |model, field, value|
      # model.send(field).default_city = value
    end


    # Converts an object of this instance into a database friendly value.
    def mongoize
      @phone.to_s
    end

    [:to_s, :free?, :cell?, :clean, :full, :inspect].each do |m|
      define_method(m) do
        @phone.send(m)
      end
    end

    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        p self.fields

        RussianPhone::Number.parse(object)
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
          when RussianPhone then object.mongoize
          when String then RussianPhone::Number.parse(object).mongoize
          else object
        end
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
          when RussianPhone then object.mongoize
          else object
        end
      end
    end
  end
end
