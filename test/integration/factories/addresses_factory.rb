require "integration/factories/collection_factory"

class AddressesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].addresses, example)
  end

  def get(identity)
    @subject.get(identity, TEST_REGION)
  end

  def params
    { :name => resource_name,
      :region => TEST_REGION }
  end
end
