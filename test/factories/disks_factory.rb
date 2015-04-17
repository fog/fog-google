require "factories/collection_factory"

class DisksFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].disks, example)
  end

  def params
    {:name => test_name,
     :zone_name => TEST_ZONE,
     :size_gb => TEST_SIZE_GB}
  end
end
