require "helpers/integration_test_helper"

class TestDiskTypes < FogIntegrationTest
  NAMES = %w(local-ssd pd-ssd pd-standard).freeze
  # Testing in one random zone per region (region list as of May 2018)
  ZONES = %w(asia-east1-a asia-northeast1-b asia-south1-c asia-southeast1-a australia-southeast1-b
             europe-west1-c europe-west2-a europe-west3-b europe-west4-c northamerica-northeast1-a
             southamerica-east1-b us-central1-c us-east1-b us-east4-a us-west1-c).freeze

  def setup
    @subject = Fog::Compute[:google].disk_types
  end

  def test_all
    assert_operator(@subject.all.size, :>=, NAMES.size * ZONES.size,
                    "Number of all disk type references should be greater or equal to test zones * disk types")
  end

  def test_get
    NAMES.each do |name|
      ZONES.each do |zone|
        refute_nil @subject.get(name, zone)
      end
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
