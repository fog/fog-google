require "helpers/integration_test_helper"

class TestMachineTypes < FogIntegrationTest
  # List of machine types - not a complete sampling since beefier ones do not
  # exist in all zones (list last updated June 2018)
  NAMES = %w(f1-micro g1-small n1-highcpu-16 n1-highcpu-2 n1-highcpu-4
             n1-highcpu-8 n1-highmem-16 n1-highmem-2 n1-highmem-32 n1-highmem-4
             n1-highmem-8 n1-standard-1 n1-standard-16 n1-standard-2
             n1-standard-32 n1-standard-4 n1-standard-8 ).freeze

  # Testing in one random zone per region (list last updated May 2018)
  ZONES = %w(asia-east1-a asia-northeast1-b asia-south1-c asia-southeast1-a
             australia-southeast1-b europe-west1-c europe-west2-a europe-west3-b
             europe-west4-c northamerica-northeast1-a southamerica-east1-b
             us-central1-c us-east1-b us-east4-a us-west1-c).freeze

  def setup
    @subject = Fog::Compute[:google].machine_types
  end

  def test_all
    assert_operator(@subject.all.size, :>=, NAMES.size * ZONES.size,
                    "Number of all machine types should be greater or equal to test zones * machine_types")
  end

  def test_scoped_all
    subject_list = @subject.all
    scoped_subject_list = @subject.all(zone: TEST_ZONE)

    # Assert that whatever .all(scope) returns is a subset of .all
    assert(scoped_subject_list.all? { |x| subject_list.include? x },
           "Output of @subject.all(zone:#{TEST_ZONE}) must be a subset of @subject.all")
  end

  def test_get
    # This tests only in last zone since not all zones contain all machine types
    NAMES.each do |name|
      ZONES.each do |zone|
        refute_nil @subject.get(name, zone)
      end
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name", ZONES.first)
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end

  def test_nil_get
    assert_nil @subject.get(nil)
  end
end
