require "integration/factories/collection_factory"

class InstanceGroupsFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].instance_groups, example)
  end

  def get(identity)
    @subject.get(identity, TEST_ZONE)
  end

  def all
    @subject.all(zone: TEST_ZONE)
  end

  def params
    { :name => resource_name,
      :zone => TEST_ZONE }
  end
end
