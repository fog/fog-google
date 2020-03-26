require "helpers/integration_test_helper"

class TestCommonFlags < FogIntegrationTest
  def setup
    @client = Fog::Google::SQL.new
  end

  def test_list
    resp = @client.list_flags

    assert_operator(resp.items.size, :>, 0,
                    "resource descriptor count should be positive")

    _sanity_check_flag(resp.items.first)
  end

  def test_all
    resp = @client.flags.all

    assert_operator(resp.size, :>, 0,
                    "resource descriptor count should be positive")

    _sanity_check_flag(resp.first)
  end

  def _sanity_check_flag(flag)
    assert_equal(flag.kind, "sql#flag")
    refute(flag.name.nil?, "flag name should not be empty")
    refute_empty(flag.applies_to, "flag should apply to some database version")
  end
end
