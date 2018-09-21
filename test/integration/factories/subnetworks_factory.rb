require "integration/factories/collection_factory"

class SubnetworksFactory < CollectionFactory
  def initialize(example)
    # We cannot have 2 subnetworks with the same CIDR range so instantiating a
    # class variable holding a generator, ensuring that the factory gives us a
    # new subnet every time it's called
    @octet_generator = (0..255).each
    super(Fog::Compute[:google].subnetworks, example)
  end

  def get(identity)
    @subject.get(identity, TEST_REGION)
  end

  def params
    { :name => resource_name,
      :network => "default",
      :region => TEST_REGION,
      :ip_cidr_range => "192.168.#{@octet_generator.next}.0/24" }
  end
end
