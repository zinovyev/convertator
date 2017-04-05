require 'net/http'
require 'pry'
require 'rexml/document'

module Convertator
  module Providers
    class CbrProvider
      SERVICE_URI = 'http://www.cbr.ru/scripts/xml_daily.asp'

      def new_rates 
        default_rates.merge parse(fetch)
      end

      private

      def default_rates
        {
          RUB: "1",
        }
      end

      def parse(data)
        doc = REXML::Document.new(data)
        rates = {}
        doc.elements.each('ValCurs/Valute') do |valute|
          code = REXML::XPath.first(valute, 'CharCode/text()').to_s
          val = REXML::XPath.first(valute, 'Value/text()').to_s
          rates[code.upcase.to_sym] = val
        end
        rates
      end

      def fetch
        uri = URI(SERVICE_URI)
        ::Net::HTTP.get(uri) 
      end
    end
  end
end
