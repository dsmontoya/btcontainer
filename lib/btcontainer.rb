require 'mexbt'

Dir["#{File.dirname(__FILE__)}/btcontainer/**/*.rb"].each { |f| require(f) }

module BTContainer
  class << self
    def clients
      BTContainer::Clients.constants.collect do |c|
        BTContainer::Clients.const_get(c)
      end
    end

    def exchanges
      clients.collect do |client|
        client.exchange
      end
    end

    def client_for_exchange exchange
      exchange = exchange.to_sym unless exchange.is_a?(Symbol)
      clazz = BTContainer::Clients.constants.find do |c|
        clazz = BTContainer::Clients.const_get(c)
        clazz.exchange == exchange
      end
      begin
        clazz = BTContainer::Clients.const_get(clazz)
      rescue TypeError => e
        raise ArgumentError, "Invalid exchange - '#{exchange}'"
      end
    end
  end
end

class Hash
  def to_ostruct
    arr = map do |k, v|
      case v
      when Hash
        [k, v.to_ostruct]
      when Array
        [k, v.map { |el| Hash === el ? el.to_ostruct : el }]
      else
        [k, v]
      end
    end
    OpenStruct.new(Hash[arr])
  end
end 
