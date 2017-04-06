module Convertator
  class Middleware
    attr_accessor :prev

    def call
      raise ::NotImplementedError,
            'Method call should be implemented by every middleware'
    end
  end
end
