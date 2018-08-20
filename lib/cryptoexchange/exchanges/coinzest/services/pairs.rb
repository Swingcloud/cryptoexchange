module Cryptoexchange::Exchanges
  module Coinzest
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Coinzest::Market::API_URL}/api/public/market_summary"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          output['result'].map do |pair|
            target, base = pair['MarketName'].split('-')
            Cryptoexchange::Models::MarketPair.new(
              base:   base,
              target: target,
              market: Coinzest::Market::NAME
            )
          end
        end
      end
    end
  end
end
