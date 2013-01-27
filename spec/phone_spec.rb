# coding: utf-8

require 'spec_helper'

describe RussianPhone do
  describe 'clean' do
    it 'should remove everything except numbers from string' do
      RussianPhone::Number.clean('+7 (906) 111-11-11').should eq '79061111111'
    end
  end

  describe 'extract code' do
    it 'should extract code from number correctly' do
      RussianPhone::Number.extract('(906) 111-11-11', 7, 3).should eq ['906', '1111111']
      RussianPhone::Number.extract('(906) 111-11-11', 6, 4).should eq ['9061', '111111']
      RussianPhone::Number.extract('(906) 111-11-11', 5, 5).should eq ['90611', '11111']
    end
  end

  describe 'parsing' do
    it 'should parse (906) 111-11-11 number' do
      phone = RussianPhone::Number.parse('(906) 111-11-11', default_country: 7)
      phone.code.shoud eq '906'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (906) 111-11-11'
    end

    it 'should parse 111-11-11 number with default code' do
      phone = RussianPhone::Number.parse('111-11-11', default_country: 7, default_city: 123)
      phone.code.shoud eq '123'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (906) 111-11-11'
    end

    it 'should parse +7 (495) 111-11-11 number' do
      phone = RussianPhone::Number.parse('+7 (495) 111-11-11')
      phone.code.shoud eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should parse +7 (495) 111-11-11 number' do
      phone = RussianPhone::Number.parse('+7 (495) 111-11-11')
      phone.code.shoud eq '495'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (495) 111-11-11'
    end

    it 'should parse  8(4912)12-34-56 number' do
      phone = RussianPhone::Number.parse('+7 (495) 12-34-56', default_country: 7)
      phone.code.shoud eq '4912'
      phone.country.should eq '7'
      phone.number.should eq '1111111'
      phone.full.should eq '+7 (4912) 12-34-56'
    end

    it 'should parse  8(34356)5-67-89 number' do
      phone = RussianPhone::Number.parse('8(34356)5-67-89', default_country: 7)
      phone.code.shoud eq '34356'
      phone.country.should eq '7'
      phone.number.should eq '56789'
      phone.full.should eq '+7 (34356) 5-67-89'
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
        '8 927 1234 234' => [7, 927, 1234567],
        '8 927 12 12 234' => [7, 927, 1212234],
        '8 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '8 927 12 34 234' => [7, 927, 1234234],
        '8 927 12 342 34' => [7, 927, 1234234],
        '8 927 123-4-234' => [7, 927, 1234234],
        '8 (927) 12 342 34' => [7, 927, 1234234],
        '8-(927)-12-342-34' => [7, 927, 1234234],
        '+7 927 1234 234' => [7, 927, 1234567],
        '+7 927 12 12 234' => [7, 927, 1212234],
        '+7 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '+7 927 12 34 234' => [7, 927, 1234234],
        '+7 927 12 342 34' => [7, 927, 1234234],
        '+7 927 123-4-234' => [7, 927, 1234234],
        '+7 (927) 12 342 34' => [7, 927, 1234234],
        '+7-(927)-12-342-34' => [7, 927, 1234234],
        '7 927 1234 234' => [7, 927, 1234567],
        '7 927 12 12 234' => [7, 927, 1212234],
        '7 927 1 2 3 4 2 3 4' => [7, 927, 1234234],
        '7 927 12 34 234' => [7, 927, 1234234],
        '7 927 12 342 34' => [7, 927, 1234234],
        '7 927 123-4-234' => [7, 927, 1234234],
        '7 (927) 12 342 34' => [7, 927, 1234234],
        '7-(927)-12-342-34' => [7, 927, 1234234],
    }

    tests.each_pair do |str, result|
      it "should parse #{str}" do
        phone = RussianPhone::Number.parse(str, default_country: 7)
        phone.country.should eq result[0].to_s
        phone.city.should eq result[1].to_s
        phone.number.should eq result[2].to_s
        phone.clean.should eq "#{result[0]}#{result[1]}#{result[2]}"
      end
    end
  end
end