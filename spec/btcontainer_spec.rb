require 'spec_helper'

describe BTContainer do
  let(:clients) {BTContainer.clients}
  let(:exchanges) {BTContainer.exchanges}

  describe '#clients' do
    it_behaves_like 'an array with items' do
      let(:array) {clients}
    end
  end

  describe '#exchanges' do
    it_behaves_like 'an array with items' do
      let(:array) {exchanges}
    end

    it 'is a collection of exchanges' do
      collection = clients.collect{|client| client.exchange}
      expect(collection).to eq(exchanges)
    end
  end

  BTContainer.exchanges.each do |exchange|
    describe "#client_for_exchange(#{exchange})" do
      let(:client_for_exchange) {BTContainer.client_for_exchange exchange}

      it 'returns the correct exchange' do
        expect(client_for_exchange.new.exchange).to eq(exchange)
      end
    end
  end
end


# describe BTContainer::Clients::MexbtClient do
#   let(:mexbt) {BTContainer::Clients::MexbtClient.new public_key: ENV['MEXBT_PUBLIC_KEY_SANDBOX'], private_key: ENV['MEXBT_PRIVATE_KEY_SANDBOX'], user_id: ENV['MEXBT_USER_ID_SANDBOX'], sandbox: true}

#   describe '#balance' do
#     it 'returns the balance correctly' do
#       balances = mexbt.balance
#       puts balances
#     end
#   end
# end