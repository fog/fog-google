require "helpers/integration_test_helper"
require "integration/factories/target_pools_factory"

class TestTargetPools < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_pools
    @factory = TargetPoolsFactory.new(namespaced_name)
    @servers = Fog::Compute[:google].servers
  end

  # Override to include zone in get request
  def get_resource(identity)
    @subject.get(identity, TEST_ZONE)
  end

  def test_get_health
    target_pool = @factory.create
    server = @servers.get(target_pool.instances[0].split("/").last)
    server.wait_for { ready? }

    # There's no way to track the readiness of the instance resource in a target pool,
    # so wrapping in a soft retry:
    begin
      retries ||= 0
      target_pool.get_health
    rescue ::Google::Apis::ClientError
      sleep 25
      retry if (retries += 1) < 3
    end

    assert_equal(target_pool.get_health[server.self_link][0][:instance], server.self_link,
                 "target_pool should return instance health details")
    assert_equal(target_pool.get_health(server.name)[server.self_link][0][:instance], server.self_link,
                 "target_pool should return instance health details when an instance is specified")
  end
end
