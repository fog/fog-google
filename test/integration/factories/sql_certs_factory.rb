require "integration/factories/collection_factory"
require "integration/factories/sql_instances_factory"

class SqlCertsFactory < CollectionFactory
  def initialize(example)
    @instances = SqlInstancesFactory.new(example)
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
