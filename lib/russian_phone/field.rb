# coding: utf-8

module RussianPhone
  class Field
    attr_accessor :options
    def initalize(options)
      @options = Number.process_options(options)
    end

  end
end