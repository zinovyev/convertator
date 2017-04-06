module Convertator
  module Utils
    def symbolize_keys(array)
      array.each_with_object({}) do |(k, v), memo|
        memo[normalize_currency(k)] = v
      end
    end

    def normalize_currency(currency)
      currency.to_sym.upcase
    end
  end
end
