require "integration/factories/collection_factory"

class GlobalAddressesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].global_addresses, example)
  end

  def get(identity)
    @subject.get(identity)
  end

  def params
    { :name => resource_name }
  end
end
