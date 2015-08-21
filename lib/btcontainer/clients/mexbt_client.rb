module BTContainer
  module Clients
    class MexbtClient
      include BTContainer::Client

      class << self
        def exchange
          :mexbt
        end
      end

      def initialize config={}
        @options = config
      end

      def balance
        curr = interface.balance[:currencies]
        hash = {}

        currencies.each_with_index do |item, index|
          hash[item] = curr[index]
        end

        hash.to_ostruct
      end

      def cancel_order options={}
        Mexbt.cancel_order options
      end

      def currencies
        [:usd, :btc, :ltc, :cny, :mxn]
      end

      def interface
        @interface ||= Mexbt::Account.new(public_key: @options[:public_key], private_key: @options[:private_key], user_id: @options[:user_id], sandbox: @options[:sandbox] || false)
      end

      def order_book currency: :btcmxn
        order_book = Mexbt.order_book(currency_pair: currency)
        hash = {}
        [:bids, :asks].each do |type|
          arr = []
          order_book[type].each do |item|
            arr << {amount: item[:qty], price: item[:px]}
          end
          hash[type] = arr
        end

        hash.to_ostruct
      end

      def ticker options={}
        Mexbt.ticker options
      end

      def trade side, options={}
        interface.create_order(amount: options[:amount], price: options[:price], side: side, currency_pair: options[:currency], type: :limit)
      end

      def trades options={}
        Mexbt.trades options
      end
    end
  end
end