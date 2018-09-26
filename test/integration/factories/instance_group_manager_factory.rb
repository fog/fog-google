require "integration/factories/collection_factory"
require "integration/factories/instance_template_factory"

class InstanceGroupManagerFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].instance_group_managers, example)
    @instance_template = InstanceTemplateFactory.new(example)
  end

  def cleanup
    super
    @instance_template.cleanup
  end

  def get(identity)
    @subject.get(identity, TEST_ZONE)
  end

  def all
    @subject.all(zone: TEST_ZONE)
  end

  def params
    { :name => resource_name,
      :zone => TEST_ZONE,
      :base_instance_name => resource_name,
      :target_size => 1,
      :instance_template => @instance_template.create }
  end
end
