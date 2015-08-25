require 'spec_helper'

describe BTContainer::Clients::MexbtClient do
  let(:mexbt) {BTContainer::Clients::MexbtClient.new public_key: ENV['MEXBT_PUBLIC_KEY_SANDBOX'], private_key: ENV['MEXBT_PRIVATE_KEY_SANDBOX'], user_id: ENV['MEXBT_USER_ID_SANDBOX'], sandbox: true}
  let(:currencies) {mexbt.currencies}
  let(:currency_pairs) {mexbt.currency_pairs}
  let(:balance) {mexbt.balance}

  describe '#balance' do
    it 'returns the correct currencies' do
      currencies.each do |currency|
        expect(balance.send(currency)).to be_truthy
      end
    end
  end

  describe '#currencies' do
    it_behaves_like 'an array with items' do
      let(:array) {currencies}
    end
    it 'returns the same currencies than balance does' do
      balance.to_h.each do |k, v|
        expect(currencies).to include k 
      end
    end
  end

  describe '#order_book' do
    it 'returns order book for each currency_pair' do
      currency_pairs.each do |currency_pair|
        order_book = mexbt.order_book currency_pair: currency_pair
        [:bids, :asks].each do |side|
          order_book.send(side).each do |item|
            [:amount, :price].each do |method|
              expect(item.send(method)).to be_truthy
            end
          end
        end
      end
    end
  end

  describe '#open_orders' do
    it 'returns open_orders' do
      puts mexbt.open_orders
    end
  end

  describe '#ticker' do
    it 'returns ticker' do
      mexbt.ticker.high
    end
  end

  describe '#trades' do
    it 'returns trades' do
      mexbt.trades
    end
  end
end