require "integration/factories/collection_factory"
require "integration/factories/sql_v1_instances_factory"

class SqlV1UsersFactory < CollectionFactory
  def initialize(example)
    @instances = SqlV1InstancesFactory.new(example)
    super(Fog::Google[:sql].users, example)
  end

  def cleanup
    # Users will be cleaned up with the test instance.
    @instances.cleanup
  end

  def params
    # Username should not be longer than 16 characters
    { :name => resource_name[0..15],
      :instance => @instances.create.name }
  end
end
