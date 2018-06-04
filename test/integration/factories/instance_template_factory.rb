require "integration/factories/collection_factory"

class InstanceTemplateFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].instance_templates, example)
  end

  def params
    {
      :name => resource_name,
      # TODO: This needs to be populated
      :properties => {}
    }
  end
end
