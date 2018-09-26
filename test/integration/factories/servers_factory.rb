require "integration/factories/collection_factory"
require "integration/factories/disks_factory"

class ServersFactory < CollectionFactory
  def initialize(example)
    @disks = DisksFactory.new(example)
    super(Fog::Compute[:google].servers, example)
  end

  def cleanup
    # Disk cleanup sometimes fails if server deletion has not been completed
    super(false)
    @disks.cleanup
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
      :machine_type => TEST_MACHINE_TYPE,
      :disks => [@disks.create] }
  end
end
