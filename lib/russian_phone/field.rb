# coding: utf-8

module RussianPhone
  class Field
    attr_accessor :options

    def initialize(options = {})
      @options = Number.process_options(options)
    end

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      RussianPhone::Number.new(object, @options)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
        when RussianPhone::Number then object.mongoize
        when String then RussianPhone::Number.new(object, @options).mongoize
        else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
        when RussianPhone::Number then object.mongoize
        else object
      end
    end
  end
end