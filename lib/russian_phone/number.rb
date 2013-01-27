# coding: utf-8

module RussianPhone
  class Number
    # attr_accessor :phone

    def initialize(phone)
      @phone = phone.to_s
      puts "instantiated #{inspect} from #@phone"
    end

    def inspect
      @phone
    end

    def split(format, number)
      format.inject([]) do |result, size|
        result << number.slice!(0..size-1)
        return result if number.empty?
        result
      end
    end

    def parse(field)
      data = self.class.parse(@phone)
      puts "parsed #{@phone} to #{data.to_s}"
      if data.has_key? :number
        @number = data[:number]
        @city = data[:city]
        @country = data[:country]
      end
      data.has_key?(field) ? data[field] : nil
    end

    def valid?
      @valid ||= !(country.nil? || city.nil? || number.nil? || @country == '' || @city == ''  || @number == '')
    end

    def number
      @number ||= parse(:number)
    end

    def city
      @city ||= parse(:city)
    end

    def country
      @country ||= parse(:country)
    end

    def format
      if number.to_s.length == 7
        split([3, 2, 2], number)
      elsif number.to_s.length == 6
        split([2, 2, 2], number)
      elsif number.to_s.length == 5
        split([1, 2, 2], number)
      else
        []
      end
    end

    def full
      if valid?
        if free?
        "8-#@city-#{format.join('-')}"
        else
        "+#@country (#@city) #{format.join('-')}"
        end
      else
        ''
      end
    end

    alias_method(:to_s, :full)
    alias_method(:inspect, :full)

    def clean
      "#@country#@city#@number"
    end

    def cell?
      Codes.cell_codes.include?(@city)
    end

    def free?
      @city == '800'
    end

    ::Mongoid::Fields.option :allowed_codes do |model, field, value|
      p model, field, value
      #model.send(field).allowed_codes = value
    end
    ::Mongoid::Fields.option :default_country do |model, field, value|
      # model.send(field).default_country = value
    end
    ::Mongoid::Fields.option :default_city do |model, field, value|
      # model.send(field).default_city = value
    end

    def mongoize
      full
    end

    class << self
      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        p "demongoize", object, object.class.name, object.inspect
        RussianPhone::Number.parse(object)
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
          when RussianPhone then object.mongoize
          when String then RussianPhone::Number.new(object).mongoize
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

      def clean(string)
        string.tr('^0-9', '')
      end

      def _extract(string, local_digits, code_digits)
        [string[-(local_digits + code_digits), code_digits], string[-local_digits,local_digits]]
      end

      def extract(string, local_digits, code_digits)
        _extract(clean(string), local_digits, code_digits)
      end

      def country_code(string)
        clean(string)[-10, 1]
      end

      def parse(string, opts = {})
        return string if string.class.name == 'RussianPhone::Number'

        opts = {
            default_country: 7,
            default_city: nil
        }.merge(opts)

        opts[:default_country] = opts[:default_country].to_s unless opts[:default_country].nil?
        opts[:default_city]    = opts[:default_city].to_s    unless opts[:default_city].nil?

        if string.class.name == 'Array'
          string = string.join('')
        else
          string = string.to_s
        end

        clean_string = clean(string)

        if clean_string.length > 11
          return nil
        end

        if clean_string.length < 10
          if opts[:default_city].nil?
            return nil
          elsif clean_string.length > 7
            # Телефон слишком длинный для телефона без кода города
            return nil
          else
            if Codes.codes_for(clean_string.length).include? opts[:default_city]
              return {country: opts[:default_country], city: opts[:default_city], number: clean_string}
            else
              # Количество цифр в телефоне не соответствует количеству цифр местных номеров города
              return nil
            end
          end
        end

        code_3_digit, phone_7_digit = _extract(clean_string, 7, 3)
        if code_3_digit == '800' || Codes.cell_codes.include?(code_3_digit) || Codes.ndcs_with_7_subscriber_digits.include?(code_3_digit)
          return {country: opts[:default_country], city: code_3_digit, number: phone_7_digit}
        end

        code_4_digit, phone_6_digit = _extract(clean_string, 6, 4)
        if Codes.ndcs_with_6_subscriber_digits.include? code_4_digit
          return {country: opts[:default_country], city: code_4_digit, number: phone_6_digit}
        end

        code_5_digit, phone_5_digit = _extract(clean_string, 5, 5)
        if Codes.ndcs_with_5_subscriber_digits.include? code_5_digit
          return {country: opts[:default_country], city: code_5_digit, number: phone_5_digit}
        end

        nil
      end
    end
  end
end