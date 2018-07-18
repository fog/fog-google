require "integration/factories/collection_factory"

class InstanceTemplateFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].instance_templates, example)
  end

  def params
    {
      :name => resource_name,
      # TODO: Properties config is convoluted, needs to be refactored
      :properties => {
          :machine_type => TEST_MACHINE_TYPE,
          :disks => [{
                         :boot => true,
                         :auto_delete => true,
                         :initialize_params =>
                          { :source_image => "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180522" }
                     }],
          :network_interfaces => [{ :network => "global/networks/default" }]
      }
    }
  end
end
