require 'spec_helper'

describe BTContainer::Clients::MexbtClient do
  let(:mexbt) {BTContainer::Clients::MexbtClient.new public_key: ENV['MEXBT_PUBLIC_KEY_SANDBOX'], private_key: ENV['MEXBT_PRIVATE_KEY_SANDBOX'], user_id: ENV['MEXBT_USER_ID_SANDBOX'], sandbox: true}
  let(:currencies) {mexbt.currencies}
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
        expect(currencies).to include v.name.downcase.to_sym 
      end
    end
  end

  describe '#order_book' do
    [:btcmxn, :btcusd, :btcbrl].each do |currency|
      it "returns order book for #{currency}" do
        mexbt.order_book currency: currency
      end
    end
  end
end