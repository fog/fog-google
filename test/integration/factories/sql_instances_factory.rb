require "integration/factories/collection_factory"

class SqlInstancesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Google[:sql].instances, example)
  end

  def cleanup
    super
  end

  def params
    # Name has a time suffix due to SQL resources API objects having
    # a _very_ long life on the backend (n(days)) after deletion.
    { :name => "#{resource_name}-#{Time.now.to_i}",
      :region => TEST_SQL_REGION,
      :tier => TEST_SQL_TIER }
  end
end
