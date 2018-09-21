require "integration/factories/collection_factory"

class NetworksFactory < CollectionFactory
  def initialize(example)
    # We cannot have 2 networks with the same IP range so instantiating a
    # class variable holding a generator, ensuring that the factory gives
    # us a new network every time it's called
    @octet_generator = (0..255).each
    super(Fog::Compute[:google].networks, example)
  end

  def params
    { :name => resource_name,
      :ipv4_range => "172.16.#{@octet_generator.next}.0/24" }
  end
end
