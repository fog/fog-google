require "factories/collection_factory"
require "factories/servers_factory"
require "factories/http_health_checks_factory"

class TargetPoolsFactory < CollectionFactory
  def initialize
    @subject = Fog::Compute[:google].target_pools
    @http_health_checks = HttpHealthChecksFactory.new
    @servers = ServersFactory.new
    super
  end

  def cleanup
    super
    @servers.cleanup
    @http_health_checks.cleanup
  end

  def params
    params = {:name => test_name,
              :region => TEST_REGION,
              :instances => [@servers.create.self_link],
              :healthChecks => [@http_health_checks.create.self_link]}
  end
end
