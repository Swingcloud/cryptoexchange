module Cryptoexchange::Exchanges
  module Coinzest
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super(ticker_url)
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Coinzest::Market::API_URL}/api/public/market_summary"
        end

        def adapt_all(output)
          output['result'].map do |ticker|
            target, base = ticker['MarketName'].split('-')
            market_pair  = Cryptoexchange::Models::MarketPair.new(
              base:   base,
              target: target,
              market: Coinzest::Market::NAME
            )
            adapt(market_pair, ticker)
          end
        end

        def adapt(market_pair, output)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Coinzest::Market::NAME
          ticker.last      = NumericHelper.to_d(output['Last'])
          ticker.high      = NumericHelper.to_d(output['High'])
          ticker.low       = NumericHelper.to_d(output['Low'])
          ticker.bid       = NumericHelper.to_d(output['Bid'])
          ticker.ask       = NumericHelper.to_d(output['Ask'])
          ticker.volume    = NumericHelper.divide(NumericHelper.to_d(output['Volume']), ticker.last)
          ticker.timestamp = NumericHelper.to_d(output['Created']) / 1000
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
