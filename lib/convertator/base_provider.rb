module Convertator
  class BaseProvider
    def new_rates
      raise ::NotImplementedError,
        "Method new_rates should be implemented by every rates provider"
    end
  end
end
