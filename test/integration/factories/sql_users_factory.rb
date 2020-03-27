require "integration/factories/collection_factory"
require "integration/factories/sql_instances_factory"

class SqlUsersFactory < CollectionFactory
  def initialize(example)
    @instances = SqlInstancesFactory.new(example)
    super(Fog::Google[:sql].users, example)
  end

  def cleanup
    # Users will be cleaned up with the test instance.
    @instances.cleanup
  end

  def params
    # Username should not be longer than 16 characters
    { :name => resource_name[0..15],
      # TODO: Consider removing host when Users.list API issue is resolved
      # See https://github.com/fog/fog-google/issues/462
      :host => "%",
      :instance => @instances.create.name }
  end
end
