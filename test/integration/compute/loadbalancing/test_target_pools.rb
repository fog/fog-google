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

    # XXX This is not partucularly elegant but if the instance doesn't respond
    # to the healthcheck at all (for example there's nothing listening) it'll
    # enter "No instance health info was found." state, during which the API
    # will return an empty health object instead of UNHEALTHY.
    # To avoid setting up a brittle environment with a live healthcheck we just
    # stop the instance so health check returns UNHEALTHY and we can test that
    # all fields are returned correctly.
    server.stop
    server.wait_for { stopped? }

    # There's no way to track the readiness of the instance resource in a target pool,
    # so wrapping in a soft retry:
    begin
      retries ||= 0
      target_pool.get_health
    rescue ::Google::Apis::ClientError
      sleep 25
      retry if (retries += 1) < 3
    end

    refute_empty(target_pool.health_checks, "Target pool should have a health check")
    assert_equal(2, target_pool.instances.count, "Target pool should have 2 instances")
    assert_equal([{ :health_state => "UNHEALTHY",
                    :instance => server.self_link }],
                 target_pool.get_health[server.self_link],
                 "Target pool should return a proper health check list")
    assert_equal({ server.self_link =>
                      [{ :health_state => "UNHEALTHY",
                         :instance => server.self_link }] },
                 target_pool.get_health(server.name),
                 "target_pool should return instance health details when an instance is specified")
  end
end
