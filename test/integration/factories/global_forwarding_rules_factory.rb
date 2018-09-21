require "integration/factories/collection_factory"
require "integration/factories/target_http_proxies_factory"

class GlobalForwardingRulesFactory < CollectionFactory
  def initialize(example)
    @targets = TargetHttpProxiesFactory.new(example)
    super(Fog::Compute[:google].global_forwarding_rules, example)
  end

  def cleanup
    super
    @targets.cleanup
  end

  def params
    { :name => resource_name,
      :port_range => "80-80",
      :target => @targets.create.self_link }
  end
end
