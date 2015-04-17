require "factories/collection_factory"
require "factories/target_pools_factory"

class ForwardingRulesFactory < CollectionFactory
  def initialize(example)
    @target_pools = TargetPoolsFactory.new(example)
    super(Fog::Compute[:google].forwarding_rules, example)
  end

  def cleanup
    super
    @target_pools.cleanup
  end

  def params
    params = {:name => test_name,
              :region => TEST_REGION,
              :target => @target_pools.create.self_link}
  end
end

