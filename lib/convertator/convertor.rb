require 'pry'

module Convertator
  class Convertor
    class UnknownCurrencyError < StandardError; end

    attr_reader :provider

    def initialize(provider = :cbr)
      @provider = load_provider(provider)
    end

    def rates
      rates ||= @provider.new_rates
    end

    def rate(currency)
      currency = normalize_currency(currency)
      raise UnknownCurrencyError unless rates[currency]
      rates[currency] 
    end

    def ratio(currency_from, currency_to)
      rate(currency_from).to_f / rate(currency_to).to_f
    end

    def convert(amount, currency_from, currency_to)
      amount * ratio(currency_from, currency_to)
    end

    private

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
