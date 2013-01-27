# coding: utf-8

require 'spec_helper'

describe RussianPhone do
  describe 'clean' do
    it 'should remove everything except numbers from string' do
      RussianPhone::Number.clean('+7 (906) 111-11-11').should eq '79061111111'
    end
  end

  describe 'extract city' do
    it 'should extract city from number correctly' do
      RussianPhone::Number.extract('(906) 111-11-11', 7, 3).should eq ['906', '1111111']
      RussianPhone::Number.extract('(906) 111-11-11', 6, 4).should eq ['9061', '111111']
      RussianPhone::Number.extract('(906) 111-11-11', 5, 5).should eq ['90611', '11111']
    end
  end

  describe 'when parsing' do
    it 'should parse 8-800-111-11-11 number' do
      phone = RussianPhone::Number.parse('8-800-111-11-11', default_country: 7)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_true

      phone.city.should eq '800'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '8-800-111-11-11'
    end

    it 'should parse (906) 111-11-11 number' do
      phone = RussianPhone::Number.parse('(906) 111-11-11', default_country: 7)
      phone.should_not be_nil

      phone.cell?.should be_true
      phone.free?.should be_false

      phone.city.should eq '906'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (906) 111-11-11'
    end

    it 'should parse 111-11-11 number with default city' do
      phone = RussianPhone::Number.parse('111-11-11', default_country: 7, default_city: 495)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should not parse 111-11-11 number without default city' do
      phone = RussianPhone::Number.parse('111-11-11', default_country: 7)
      phone.should be_nil
    end

    it 'should parse 1111111 number with default city' do
      phone = RussianPhone::Number.parse('1111111', default_country: 7, default_city: 495)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should parse +7 (495) 111-11-11 number' do
      phone = RussianPhone::Number.parse('+7 (495) 111-11-11')
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should parse +7 (495) 111-11-11 number' do
      phone = RussianPhone::Number.parse('+7 (495) 111-11-11')
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should parse  8(4912)12-34-56 number' do
      phone = RussianPhone::Number.parse('+7 (4912) 12-34-56', default_country: 7)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '4912'
      phone.country.should eq '7'
      phone.number.should eq '123456'
      phone.full.should eq '+7 (4912) 12-34-56'
    end

    it 'should parse  12-34-56 number whith default city' do
      phone = RussianPhone::Number.parse('12-34-56', default_country: 7, default_city: 4912)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '4912'
      phone.country.should eq '7'
      phone.number.should eq '123456'
      phone.full.should eq '+7 (4912) 12-34-56'
    end

    it 'should parse 8(34356)5-67-89 number correctly' do
      # это номер в Екатеринбурге, с неправильно указанным кодом города

      phone = RussianPhone::Number.parse('8(34356)5-67-89', default_country: 7)
      phone.should_not be_nil

      phone.cell?.should be_false
      phone.free?.should be_false

      phone.city.should eq '343'
      phone.country.should eq '7'
      phone.number.should eq '5656789'
      phone.full.should eq '+7 (343) 565-67-89'
    end

    tests = {
        '+79261234567' => [7, 926, 1234567],
        '89261234567' => [7, 926, 1234567],
        '79261234567' => [7, 926, 1234567],
        '+7 926 123 45 67' => [7, 926, 1234567],
        '8(926)123-45-67' => [7, 926, 1234567],
        '8 (926) 12-3-45-67' => [7, 926, 1234567],
        '9261234567' => [7, 926, 1234567],
        '(495)1234567' => [7, 495, 1234567],
        '(495)123 45 67' => [7, 495, 1234567],
        '8-926-123-45-67' => [7, 926, 1234567],
        '8 927 1234 234' => [7, 927, 1234234],
        '8 927 12 12 234' => [7, 927, 1212234],
        '8 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '8 927 12 34 234' => [7, 927, 1234234],
        '8 927 12 342 34' => [7, 927, 1234234],
        '8 927 123-4-234' => [7, 927, 1234234],
        '8 (927) 12 342 34' => [7, 927, 1234234],
        '8-(927)-12-342-34' => [7, 927, 1234234],
        '+7 927 1234 234' => [7, 927, 1234234],
        '+7 927 12 12 234' => [7, 927, 1212234],
        '+7 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '+7 927 12 34 234' => [7, 927, 1234234],
        '+7 927 12 342 34' => [7, 927, 1234234],
        '+7 927 123-4-234' => [7, 927, 1234234],
        '+7 (927) 12 342 34' => [7, 927, 1234234],
        '+7-(927)-12-342-34' => [7, 927, 1234234],
        '7 927 1234 234' => [7, 927, 1234234],
        '7 927 12 12 234' => [7, 927, 1212234],
        '7 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '7 927 12 34 234' => [7, 927, 1234234],
        '7 927 12 342 34' => [7, 927, 1234234],
        '7 927 123-4-234' => [7, 927, 1234234],
        '7 (927) 12 342 34' => [7, 927, 1234234],
        '7-(927)-12-342-34' => [7, 927, 1234234],
        '7 84543 123 12' => [7, 84543, 12312],
    }

    tests.each_pair do |str, result|
      it "should parse #{str}" do
        phone = RussianPhone::Number.parse(str, default_country: 7)
        phone.should_not be_nil

        if %w(927 926).include? result[1].to_s
          phone.cell?.should be_true
        else
          phone.cell?.should be_false
        end

        phone.free?.should be_false

        phone.country.should eq result[0].to_s
        phone.city.should eq result[1].to_s
        phone.number.should eq result[2].to_s
        phone.clean.should eq "#{result[0]}#{result[1]}#{result[2]}"
      end
    end

    bad_phones = [
        '123 123',
        '11 11 11 11 11 11 11',
        '123',
        'пыщ пыщ ололо я водитель НЛО',
        '11 11 11 11 1'
    ]

    bad_phones.each do |phone|
      it "should not parse #{phone}" do
        phone = RussianPhone::Number.parse(phone, default_country: 7)
        phone.should be_nil
      end
    end
  end

  describe 'when using ::Field' do
    it 'should serialize and deserialize correctly' do
      RussianPhone::Field.new('495 111 11 11').mongoize.should eq '+7 (495) 111-11-11'
    end
  end

  describe 'when storing with mongoid' do
    it 'should parse, store and retrieve numbers correctly' do
      u = User.create(name: 'test', phone: '906 111 11 11')
      u.save.should be_true
      u = User.first
      p u
      u.phone.should eq '+7 (906) 111-11-11'
      u.phone.cell?.should be_true
      u.phone.free?.should be_false

      u.phone.clean.should eq '79061111111'

      u.phone.country.should eq '7'
      u.phone.city.should eq '906'
      u.phone.number.should eq '1111111'
    end
  end

end