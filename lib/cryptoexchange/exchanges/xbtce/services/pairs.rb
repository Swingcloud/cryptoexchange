module Cryptoexchange::Exchanges
  module Xbtce
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Xbtce::Market::API_URL}/public/symbol"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          output.map do |pair|
            next unless /_L\z/.match(pair['Symbol']).nil?
            market_pair = Cryptoexchange::Models::MarketPair.new
            market_pair.base   = pair['MarginCurrency']
            market_pair.target = pair['ProfitCurrency']
            market_pair.market = Xbtce::Market::NAME
          end.compact
        end
      end
    end
  end
end
