require "integration/factories/collection_factory"

class NetworksFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].networks, example)
  end

  def params
    {
      :name => resource_name,
      :auto_create_subnetworks => true
    }
  end
end
