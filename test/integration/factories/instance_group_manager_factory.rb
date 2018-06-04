require "integration/factories/collection_factory"

class InstanceGroupManagerFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].instance_group_managers, example)
  end

  def params
    {:name => resource_name}
  end
end
