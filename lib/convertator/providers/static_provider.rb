module Convertator
  module Providers
    class StaticProvider < BaseProvider
      attr_writer :rates

      def initialize
        @rates = {}
      end

      def new_rates
        @rates
      end
    end
  end
end
