require "helpers/integration_test_helper"
require "helpers/client_helper"
require "securerandom"

class TestComputeDiskRequests < FogIntegrationTest
  DEFAULT_ZONE = "us-central1-a".freeze
  DISK_RESOURCE_PREFIX = "fog-test-disk".freeze

  include ClientHelper

  def delete_test_resources
    client = Fog::Compute::Google.new
    disks = client.disks.all(:zone => DEFAULT_ZONE)
    unless disks.nil?
      disks
        .select { |d| d.name.start_with?(DISK_RESOURCE_PREFIX) }
        .each do |d|
          d.wait_for { ready? }
          client.delete_disk(d.name, DEFAULT_ZONE)
        end
    end
  end

  attr_reader :client

  def setup
    @client = Fog::Compute::Google.new
  end

  def teardown
    delete_test_resources
  end

  def new_disk_name
    "#{DISK_RESOURCE_PREFIX}-#{SecureRandom.uuid}"
  end

  def some_disk_name
    # created lazily to speed tests up
    @some_disk ||= new_disk_name.tap do |a|
      result = @client.insert_disk(a, DEFAULT_ZONE, nil, :size_gb => 10)
      Fog.wait_for { operation_finished?(result) }
    end
  end

  def test_insert_disk
    result = wait_until_complete do
      @client.insert_disk(new_disk_name, DEFAULT_ZONE, nil, :size_gb => 10)
    end

    assert_equal("DONE", result.status, "request should be successful")
    assert_nil(result.error, "result should contain no errors")
  end

  def test_get_disk
    result = @client.get_disk(some_disk_name, DEFAULT_ZONE)

    assert_equal("READY", result.status, "request should be successful")
    assert_includes(result.name, some_disk_name, "resulting disk should have expected name")
  end

  def test_list_disks
    # Let's create at least one disk so there's something to view
    known_disk = some_disk_name

    result = @client.list_disks(DEFAULT_ZONE)
    assert_operator(result.items.size, :>, 0, "disk count should be positive")
    assert_includes(result.items.map(&:name), known_disk, "pre-existing disk should be present")
  end

  def test_delete_disk
    # Create something to delete
    disk_to_delete = new_disk_name
    wait_until_complete { @client.insert_disk(disk_to_delete, DEFAULT_ZONE, nil, :size_gb => 10) }

    result = wait_until_complete { @client.delete_disk(disk_to_delete, DEFAULT_ZONE) }

    assert_nil(result.error, "result should contain no errors")

    assert_raises(Google::Apis::ClientError) do
      @client.get_disk(disk_to_delete, DEFAULT_ZONE)
    end
  end

  def test_list_aggregated_disks
    @client.get_disk(some_disk_name, DEFAULT_ZONE)
    result = @client.list_aggregated_disks

    assert_operator(result.items.size, :>, 0, "address count should be positive")
    assert_includes(result.items.keys, "zones/#{DEFAULT_ZONE}", "'items' subset should contain zones/#{DEFAULT_ZONE} keyword")
  end
end
