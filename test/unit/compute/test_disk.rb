require "helpers/test_helper"

class UnitTestDisk < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Compute.new(provider: "google",
                               google_project: "foo")
  end

  def teardown
    Fog.unmock!
  end

  def test_new_disk
    disk = Fog::Compute::Google::Disk.new(
      :name         => "fog-1",
      :size_gb      => 10,
      :zone         => "us-central1-a",
      :source_image => "debian-7-wheezy-v20131120"
    )
    assert_equal("fog-1",                     disk.name,         "Fog::Compute::Google::Disk name is incorrect: #{disk.name}")
    assert_equal(10,                          disk.size_gb,      "Fog::Compute::Google::Disk size_gb is incorrect: #{disk.size_gb}")
    assert_equal("us-central1-a",             disk.zone,         "Fog::Compute::Google::Disk zone is incorrect: #{disk.zone}")
    assert_equal("debian-7-wheezy-v20131120", disk.source_image, "Fog::Compute::Google::Disk source_image is incorrect: #{disk.source_image}")
  end
end
