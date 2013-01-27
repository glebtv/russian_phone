# coding: utf-8

module RussianPhone
  class Number
    attr_accessor :country, :city, :number

    def initialize(country, city, number)
      @country = country.to_s
      @city = city.to_s
      @number = number.to_s
    end

    def inspect
      [@country, @city, @number]
    end

    def split(format, number)
      format.inject([]) do |result, size|
        result << number.slice!(0..size-1)
        return result if number.empty?
        result
      end
    end

    def format
      if @number.to_s.length == 7
        split([3, 2, 2], @number)
      elsif @number.to_s.length == 6
        split([2, 2, 2], @number)
      elsif @number.to_s.length == 5
        split([1, 2, 2], @number)
      end
    end

    def full
      if free?
        "8-#@city-#{format.join('-')}"
      else
        "+#@country (#@city) #{format.join('-')}"
      end
    end

    alias_method(:to_s, :full)
    # alias_method(:inspect, :full)

    def clean
      "#@country#@city#@number"
    end

    def cell?
      Codes.cell_codes.include?(@city)
    end

    def free?
      @city == '800'
    end

    class << self
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
              return RussianPhone::Number.new(opts[:default_country], opts[:default_city], clean_string)
            else
              # Количество цифр в телефоне не соответствует количеству цифр местных номеров города
              return nil
            end
          end
        end

        code_3_digit, phone_7_digit = _extract(clean_string, 7, 3)

        if code_3_digit == '800'
          return RussianPhone::Number.new(opts[:default_country], code_3_digit, phone_7_digit)
        end


        if Codes.cell_codes.include?(code_3_digit)
          return RussianPhone::Number.new(opts[:default_country], code_3_digit, phone_7_digit)
        end

        if Codes.ndcs_with_7_subscriber_digits.include?(code_3_digit)
          return RussianPhone::Number.new(opts[:default_country], code_3_digit, phone_7_digit)
        end

        code_4_digit, phone_6_digit = _extract(clean_string, 6, 4)
        if Codes.ndcs_with_6_subscriber_digits.include? code_4_digit
          return RussianPhone::Number.new(opts[:default_country], code_4_digit, phone_6_digit)
        end

        code_5_digit, phone_5_digit = _extract(clean_string, 5, 5)
        if Codes.ndcs_with_5_subscriber_digits.include? code_5_digit
          return RussianPhone::Number.new(opts[:default_country], code_5_digit, phone_5_digit)
        end

        nil
      end
    end
  end
end