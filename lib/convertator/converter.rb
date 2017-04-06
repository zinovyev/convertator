require 'bigdecimal'
require 'bigdecimal/util'

module Convertator
  class Converter
    class UnknownCurrencyError < StandardError; end

    attr_reader :provider

    def initialize(provider = :cbr, accuracy = 10)
      @provider = load_provider(provider)
      @accuracy = accuracy
    end

    def rates
      rates ||= @provider.new_rates
    end

    def rate(currency)
      currency = normalize_currency(currency)
      raise UnknownCurrencyError "Currency #{currency} is unknown" unless rates[currency]
      round(BigDecimal.new(rates[currency], @accuracy))
    end

    def ratio(currency_from, currency_to)
      round(rate(currency_from) / rate(currency_to))
    end

    def convert(amount, currency_from, currency_to)
      round(amount / ratio(currency_from, currency_to))
    end

    def convert_s(amount, currency_from, currency_to)
      round(convert(amount, currency_from, currency_to)).to_digits
    end

    def convert_multi(amount, currency_from, currencies_to)
      currencies_to.map do |currency_to|
        convert(amount, currency_from, currency_to)
      end
    end

    def convert_multi_s(amount, currency_from, currencies_to)
      currencies_to.map do |currency_to|
        convert_s(amount, currency_from, currency_to)
      end
    end

    private

    def round(value)
      BigDecimal.save_rounding_mode do
        BigDecimal.mode(BigDecimal::ROUND_MODE, :half_up)
        value.round(@accuracy)
      end
    end

    def load_provider(name)
      try_require(name)
      klass = Object.const_get(
        "Convertator::Providers::#{name.capitalize}Provider"
      )
      klass.new
    end

    def try_require(name)
      require ::File.join(
        __dir__,
        'providers',
        "#{name.downcase}_provider"
      )
    end

    def normalize_currency(currency)
      currency.to_sym.upcase
    end
  end
end
