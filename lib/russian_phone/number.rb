# coding: utf-8

module RussianPhone
  class Number
    attr_accessor :country, :city, :number

    def initialize(country, city, number)
      @country = country.to_s
      @city = city.to_s
      @number = number.to_s
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
      "+#@country (#@city) #{format}"
    end

    def clean
      "#@country#@city#@number"
    end

    def cell?
      Codes.cell_codes.include? @city
    end

    def free_call?
      @city == '800'
    end

    class << self
      def clean(string)
        string.tr('^0-9', '')
      end

      def extract(string, local_digits, code_digits)
        clean_string = clean(string)
        [clean_string[-(local_digits + code_digits), code_digits], clean(string)[-local_digits,local_digits]]
      end

      def country_code(string)
        clean(string)[-10, 1]
      end

      def parse(string, opts = {})
        opts = {
            default_country: 7,
            default_city: nil
        }.merge(opts)

        code_3_digit, phone_7_digit = extract(string, 7, 3)
        if Codes.cell_codes.include?(code_3_digit) || Codes.ndcs_with_7_subscriber_digits.include?(code_3_digit)
          return RussianPhone::Number.new(opts[:default_country], code_3_digit, phone_7_digit)
        end

        code_4_digit, phone_6_digit = extract(string, 6, 4)
        if Codes.ndcs_with_6_subscriber_digits.include? code_4_digit
          return RussianPhone::Number.new(opts[:default_country], code_4_digit, phone_6_digit)
        end

        code_5_digit, phone_5_digit = extract(string, 5, 5)
        if Codes.ndcs_with_5_subscriber_digits.include? code_5_digit
          return RussianPhone::Number.new(opts[:default_country], code_5_digit, phone_5_digit)
        end

        nil
      end
    end
  end
end