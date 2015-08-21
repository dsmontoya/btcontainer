require 'btcontainer'

shared_examples 'an array with items' do
  describe 'class' do
    it {expect(array).to be_a(Array)}
  end

  describe '#count' do
    it 'has at lest one item' do
      expect(array).to be_any
    end
  end
end