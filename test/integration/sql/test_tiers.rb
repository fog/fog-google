require "helpers/integration_test_helper"

class TestTiers < FogIntegrationTest
  def setup
    @client = Fog::Google::SQL.new
  end

  def test_list
    resp = @client.list_tiers

    assert_operator(resp.items.size, :>, 0,
                    "response tiers count should be positive")
    _sanity_check_tier(resp.items.first)
  end

  def test_all
    resp = @client.tiers.all

    assert_operator(resp.size, :>, 0,
                    "tier count should be positive")
    _sanity_check_tier(resp.first)
  end

  def _sanity_check_tier(tier)
    assert_equal(tier.kind, "sql#tier")
    refute(tier.tier.nil?, "tier name should not be empty")
    assert_operator(tier.disk_quota, :>, 0,
                    "tier disk quota should be positive")
    assert_operator(tier.ram, :>, 0,
                    "tier ram should be positive")
    assert_operator(tier.region.size, :>, 0,
                    "tier should have regions")
  end
end
