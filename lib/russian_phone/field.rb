# coding: utf-8

module RussianPhone
  module Field
    attr_accessor :phone

    def initialize(phone, default_country = nil, default_city = nil)
      @phone = RussianPhone::Number.parse(phone, default_country, default_city)
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      @phone
    end

    private
      def method_missing(method, *args, &block)
        @phone.send(method, *args, &block)
      end

    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        RussianPhone::Number.parse(object)
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
          when RussianPhone then object.mongoize
          when Hash then RussianPhone.new(object).mongoize
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
