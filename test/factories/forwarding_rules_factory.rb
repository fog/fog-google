require "factories/collection_factory"
require "factories/target_pools_factory"

class ForwardingRulesFactory < CollectionFactory
  def initialize
    @subject = Fog::Compute[:google].forwarding_rules
    @target_pools = TargetPoolsFactory.new
    super
  end

  def cleanup
    super
    @target_pools.cleanup
  end

  def params
    params = {:name => create_test_name,
              :region => TEST_REGION,
              :target => @target_pools.create.self_link}
  end
end

