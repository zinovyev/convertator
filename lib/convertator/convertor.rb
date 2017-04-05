module Convertator
  class Convertor
    class UnknownCurrencyError < StandardError; end

    attr_reader :rates

    def initialize(rates)
      @rates = rates
    end

    def rate(currency)
      currency = normalize_currency(currency)
      raise UnknownCurrencyError unless @rates[currency]
      @rates[currency] 
    end

    def ratio(currency_from, currency_to)
      rate(currency_from) / rate(currency_to)
    end

    def convert(value, currency_from, currency_to)
      value * ratio(currency_from, currency_to)
    end

    private

    def normalize_currency(currency)
      currency.to_sym.upcase
    end
  end
end
