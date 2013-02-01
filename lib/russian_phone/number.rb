# coding: utf-8

module RussianPhone
  class Number
    attr_accessor :phone, :options

    def initialize(phone, options = {})
      @options = self.class.process_options(options)
      @phone = phone.to_s
    end

    def ==(other)
      if other.class == self.class
        # (other.phone == self.phone && other.options == self.options)
        other.to_s == to_s
      elsif other.class == String
        parsed = RussianPhone::Number.new(other)
        parsed.to_s == to_s
        # parsed.phone == self.phone && parsed.options == self.options
      else
        false
      end
    end

    def coerce(something)
      [self, something]
    end

    def parse(field)
      data = self.class.parse(@phone, @options)
      return nil if data.nil?

      if data.has_key? :subscriber
        @subscriber = data[:subscriber].to_s
        @city = data[:city].to_s
        @country = data[:country].to_s
        @extra = data[:extra].to_s
      end

      data.has_key?(field) ? data[field] : nil
    end

    def valid?
      @valid ||= !(country.nil? || city.nil? || subscriber.nil? || country == '' || city == ''  || subscriber == '')
    end

    def subscriber
      @subscriber ||= parse(:subscriber)
    end

    def city_allowed?
      options[:allowed_cities].nil? || options[:allowed_cities].include?(city)
    end

    def city
      @city ||= parse(:city)
    end

    def country
      @country ||= parse(:country)
    end

    def extra
      @extra ||= parse(:extra)
    end

    def split(format, number)
      number = number.dup
      format.inject([]) do |result, size|
        result << number.slice!(0..size-1)
        return result if number.empty?
        result
      end
    end

    def format
      if subscriber.length == 7
        split([3, 2, 2], subscriber)
      elsif subscriber.length == 6
        split([2, 2, 2], subscriber)
      elsif subscriber.length == 5
        split([1, 2, 2], subscriber)
      else
        []
      end
    end

    def full
      if valid?
        if free? && extra == ''
        "8-#{city}-#{format.join('-')}"
        else
        "+#{country} (#{city}) #{format.join('-')}#{extra == '' ? '' : ' ' + extra}"
        end
      else
        ''
      end
    end

    def clean
      "#{country}#{city}#{subscriber}"
    end

    def cell?
      Codes.cell_codes.include?(city)
    end

    def free?
      city == '800'
    end

    # alias_method(:to_s, :full)
    # alias_method(:inspect, :full)

    def to_s
      valid? ? full : @phone
    end


    def inspect
      # '"' + full + '"'
      '"' + to_s + '"'
    end

    #def mongoize
    #  @phone
    #end
    # alias_method(:as_json, :mongoize)

    alias_method(:as_json, :to_s)
    alias_method(:mongoize, :to_s)

    class << self
      def clean(string)
        string.tr('^0-9', '')
      end

      #def _extract(string, subscriber_digits, code_digits)
      #  [string[-(subscriber_digits + code_digits), code_digits], string[-subscriber_digits,subscriber_digits]]
      #end

      def _extract(string, subscriber_digits, code_digits)
        [string[0, code_digits], string[code_digits, subscriber_digits]]
      end

      def extract(string, subscriber_digits, code_digits)
        _extract(clean(string), subscriber_digits, code_digits)
      end

      def _extra(string, position)
        i = 0
        digits = 0

        string.each_char do |char|
          if char.match(/[0-9]/)
            digits += 1
          end
          i += 1
          # puts "#{char} #{digits} #{i} #{position}"
          if digits >= position
            return string[i..-1].strip
          end
        end

        ''
      end

      def country_code(string)
        clean(string)[-10, 1]
      end

      def process_options(opts = {})
        opts = {
            default_country: 7,
            default_city: nil,
            allowed_cities: nil,
        }.merge(opts)

        opts[:default_country] = opts[:default_country].to_s unless opts[:default_country].nil?
        opts[:default_city]    = opts[:default_city].to_s    unless opts[:default_city].nil?
        opts[:allowed_cities]  = opts[:allowed_cities].map { |c| c.to_s } unless opts[:allowed_cities].nil?

        opts
      end

      def parse(string, opts = {})
        return string if string.class.name == 'RussianPhone::Number'

        opts = process_options(opts)

        if string.class.name == 'Array'
          string = string.join('')
        else
          string = string.to_s
        end

        clean_string = clean(string)

        if clean_string.length < 10
          if opts[:default_city].nil?
            return nil
          elsif clean_string.length > 7
            # Телефон слишком длинный для телефона без кода города
            return nil
          else
            if Codes.codes_for(clean_string.length).include? opts[:default_city]
              return {country: opts[:default_country], city: opts[:default_city], subscriber: clean_string}
            else
              # Количество цифр в телефоне не соответствует количеству цифр местных номеров города
              return nil
            end
          end
        end

        extra_after = 10

        if clean_string.length > 10 && string.starts_with?('+7') || string.starts_with?('8 ') || string.starts_with?('8(') || string.starts_with?('8-')
          clean_string[0] = ''
          extra_after += 1
        end

        if clean_string.length == 11 && string.starts_with?('7')
          clean_string[0] = ''
          extra_after += 1
        end

        if clean_string.length == 11 && string.starts_with?('8')
          clean_string[0] = ''
          extra_after += 1
        end

        # handles stuff like 89061010101 д. 123
        if string.split(' ').length > 1 && string.split(/\D/)[0].length > 10
          if string.starts_with?('7')
            clean_string[0] = ''
            extra_after += 1
          end

          if string.starts_with?('8')
            clean_string[0] = ''
            extra_after += 1
          end
        end

        code_3_digit, phone_7_digit = _extract(clean_string, 7, 3)
        if code_3_digit == '800' || Codes.cell_codes.include?(code_3_digit) || Codes.ndcs_with_7_subscriber_digits.include?(code_3_digit)
          return {country: opts[:default_country], city: code_3_digit, subscriber: phone_7_digit, extra: _extra(string, extra_after)}
        end

        code_4_digit, phone_6_digit = _extract(clean_string, 6, 4)
        if Codes.ndcs_with_6_subscriber_digits.include? code_4_digit
          return {country: opts[:default_country], city: code_4_digit, subscriber: phone_6_digit, extra: _extra(string, extra_after)}
        end

        code_5_digit, phone_5_digit = _extract(clean_string, 5, 5)
        if Codes.ndcs_with_5_subscriber_digits.include? code_5_digit
          return {country: opts[:default_country], city: code_5_digit, subscriber: phone_5_digit, extra: _extra(string, extra_after)}
        end

        return {country: opts[:default_country], city: code_3_digit, subscriber: phone_7_digit, extra: _extra(string, extra_after)}
      end
    end
  end
end