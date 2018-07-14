require "integration/factories/collection_factory"

class DisksFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].disks, example)
  end

  def get(identity)
    @subject.get(identity, TEST_ZONE)
  end

  def params
    { :name => resource_name,
      :zone_name => TEST_ZONE,
      :source_image => TEST_IMAGE,
      :size_gb => TEST_SIZE_GB }
  end
end
