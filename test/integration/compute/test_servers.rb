require "helpers/integration_test_helper"
require "integration/factories/servers_factory"

class TestServers < FogIntegrationTest
  include TestCollection

  # Cleanup is handled by TestCollection
  def setup
    @subject = Fog::Compute[:google].servers
    @factory = ServersFactory.new(namespaced_name)
  end

  def test_set_metadata
    server = @factory.create
    server.wait_for { ready? }
    server.set_metadata({ "foo" => "bar", "baz" => "foo" }, false)
    assert_equal [{ :key => "foo", :value => "bar" },
                  { :key=>"baz", :value=>"foo" }], server.metadata[:items]
  end
end
