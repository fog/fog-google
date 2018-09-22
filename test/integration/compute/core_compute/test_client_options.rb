require "helpers/integration_test_helper"

class TestComputeClient < FogIntegrationTest
  def test_client_options
    # XXX This is a very rudimentary test checking that proxy option is applied
    client_options = { proxy_url: "https://user:password@host:8080" }
    connection = Fog::Compute::Google.new(google_client_options: client_options)

    err = assert_raises(ArgumentError) { connection.servers.all }
    assert_match(/unsupported proxy/, err.message)
  end
end
