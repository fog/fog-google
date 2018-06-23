require "helpers/integration_test_helper"

class TestCommonTiers < FogIntegrationTest
  def setup
    @subject = Fog::Google[:sql].tiers
  end

  def test_all
    tiers = @subject.all

    assert_operator(tiers.size, :>, 0,
                    "tier count should be positive")
    _sanity_check_tier(tiers.first)
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
