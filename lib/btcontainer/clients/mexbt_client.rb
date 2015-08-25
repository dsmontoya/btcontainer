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
        [:usd, :btc, :ltc, :cny, :mxn, :sgd]
      end

      def currency_pairs
        [:btcmxn, :btcusd]
      end

      def interface
        @interface ||= Mexbt::Account.new(public_key: @options[:public_key], private_key: @options[:private_key], user_id: @options[:user_id], sandbox: @options[:sandbox] || false)
      end

      def order_book currency_pair: :btcusd
        order_book = Mexbt.order_book(currency_pair: currency_pair)
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

      def open_orders
        open_orders = interface.orders[:openOrdersInfo]

      end

      def trades currency_pair: :btcusd
        trades = interface.trades(currency_pair: currency_pair)[:trades]
      end

      def ticker currency_pair: :btcusd
        Mexbt.ticker(currency_pair: currency_pair).to_ostruct
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