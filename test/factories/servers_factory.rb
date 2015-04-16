require "factories/collection_factory"
require "factories/disks_factory"

class ServersFactory < CollectionFactory
  def initialize
    super
    @subject = Fog::Compute[:google].servers
    @disks = DisksFactory.new
  end

  def cleanup
    @disks.cleanup
    super
  end

  def params
    params = {:name => create_test_name,
              :zone_name => TEST_ZONE,
              :machine_type => TEST_MACHINE_TYPE,
              :disks => [@disks.create]}
  end
end
