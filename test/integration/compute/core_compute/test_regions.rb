require "helpers/integration_test_helper"

class TestRegions < FogIntegrationTest
  EXAMPLE_NAMES = %w(asia-east1 asia-northeast1 europe-west1 us-central1 us-east1 us-west1).freeze

  def setup
    @subject = Fog::Compute[:google].regions
  end

  def test_all
    assert_operator(@subject.all.size, :>=, EXAMPLE_NAMES.size)
  end

  def test_get
    EXAMPLE_NAMES.each do |region|
      refute_nil @subject.get(region)
    end
  end

  def test_up
    EXAMPLE_NAMES.each do |region|
      assert @subject.get(region).up?
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
