require "helpers/integration_test_helper"
require "securerandom"

class TestComputeAddresses < FogIntegrationTest
  DEFAULT_REGION = "us-central1".freeze
  ADDRESS_RESOURCE_PREFIX = "fog-test-address".freeze

  # Ensure we clean up any created resources
  Minitest.after_run do
    client = Fog::Compute::Google.new
    addresses = client.list_addresses(DEFAULT_REGION)[:body]["items"]
    unless addresses.nil?
      addresses.
        map { |a| a["name"] }.
        select { |a| a.start_with?(ADDRESS_RESOURCE_PREFIX) }.
        each { |a| client.delete_address(a, DEFAULT_REGION) }
    end
  end

  def setup
    @client = Fog::Compute::Google.new
  end

  def new_address_name
    "#{ADDRESS_RESOURCE_PREFIX}-#{SecureRandom.uuid}"
  end

  def some_address_name
    # created lazily to speed tests up
    @some_address ||= new_address_name.tap do |a|
      result = @client.insert_address(a, DEFAULT_REGION)
      Fog.wait_for { operation_finished?(result[:body]["name"]) }
    end
  end

  def operation_finished?(name)
    operation = @client.get_region_operation(DEFAULT_REGION, name)
    !%w(PENDING RUNNING).include?(operation[:body]["status"])
  end

  def wait_until_complete
    result = yield
    return result unless result[:body]["kind"] == "compute#operation"

    operation_name = result[:body]["name"]
    Fog.wait_for { operation_finished?(operation_name) }
    @client.get_region_operation(DEFAULT_REGION, operation_name)
  end

  def test_insert_address
    result = wait_until_complete { @client.insert_address(new_address_name, DEFAULT_REGION) }

    assert_equal(200, result.status, "request should be successful")
    assert_equal(nil, result[:body]["error"], "result should contain no errors")
  end

  def test_get_address
    result = @client.get_address(some_address_name, DEFAULT_REGION)

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "name", "resulting body should contain expected keys")
  end

  def test_list_address
    # Let's create at least one address so there's something to view
    wait_until_complete { @client.insert_address(new_address_name, DEFAULT_REGION) }

    result = @client.list_addresses(DEFAULT_REGION)

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "items", "resulting body should contain expected keys")
    assert_operator(result[:body]["items"].size, :>, 0, "address count should be positive")
  end

  def test_delete_address
    # Create something to delete
    address_to_delete = new_address_name
    wait_until_complete { @client.insert_address(address_to_delete, DEFAULT_REGION) }

    result = wait_until_complete { @client.delete_address(address_to_delete, DEFAULT_REGION) }

    assert_equal(200, result.status, "request should be successful")
    assert_equal(nil, result[:body]["error"], "result should contain no errors")
  end

  def test_list_aggregated_addresses
    result = @client.list_aggregated_addresses

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "items", "resulting body should contain expected keys")
    assert_includes(result[:body]["items"].keys, "global", "resulting body 'items' subset should contain global keyword")
  end
end
