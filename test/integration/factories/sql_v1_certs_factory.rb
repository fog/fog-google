require "integration/factories/collection_factory"
require "integration/factories/sql_v1_instances_factory"

class SqlV1CertsFactory < CollectionFactory
  def initialize(example)
    @instances = SqlV1InstancesFactory.new(example)
    super(Fog::Google[:sql].ssl_certs, example)
  end

  def cleanup
    # Certs will be cleaned up with the test instance.
    @instances.cleanup
  end

  def params
    # Certificate name should not be longer than 16 characters
    { :common_name => resource_name,
      :instance => @instances.create.name }
  end
end
