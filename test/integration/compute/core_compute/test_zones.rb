require "helpers/integration_test_helper"

class TestZones < FogIntegrationTest
  # Testing one random zone per region (list last updated May 2018)
  ZONES = %w(asia-east1-a asia-northeast1-b asia-south1-c asia-southeast1-a
             australia-southeast1-b europe-west1-c europe-west2-a europe-west3-b
             europe-west4-c northamerica-northeast1-a southamerica-east1-b
             us-central1-c us-east1-b us-east4-a us-west1-c).freeze

  def setup
    @subject = Fog::Compute[:google].zones
  end

  def test_all
    assert_operator(@subject.all.size, :>=, ZONES.size,
                    "Number of all zones should be greater than test zones")
  end

  def test_get
    # This tests only in last zone since not all zones contain all machine types
    ZONES.each do |name|
      zone = @subject.get(name)
      refute_nil(zone, "zones.get(#{name}) should not return nil")
      assert(zone.up?, "zones.up? should return up, unless there's an outage")
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
