require "integration/factories/collection_factory"

class SqlV2InstancesFactory < CollectionFactory
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
      :region => TEST_SQL_REGION_SECOND,
      :tier => TEST_SQL_TIER_SECOND }
  end
end
