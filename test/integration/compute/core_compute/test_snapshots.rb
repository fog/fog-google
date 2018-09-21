require "helpers/integration_test_helper"
require "securerandom"
require "base64"

class TestComputeSnapshots < FogIntegrationTest
  def setup
    @client = Fog::Compute::Google.new
    # Ensure any resources we create with test prefixes are removed
    Minitest.after_run do
      delete_test_resources
    end
  end

  def test_list_empty_snapshots
    assert_empty @client.snapshots.all
  end

  def delete_test_resources
    # nothing to do
  end
end
