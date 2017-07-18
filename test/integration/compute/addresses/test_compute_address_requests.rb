require "helpers/integration_test_helper"
require "integration/compute/addresses/addresses_shared"
require "helpers/client_helper"
require "securerandom"

class TestComputeAddressRequests < TestComputeAddressShared
  def test_insert_address
    result = wait_until_complete { @client.insert_address(new_address_name, DEFAULT_REGION) }

    assert_equal("DONE", result.status, "request should be successful")
    assert_nil(result.error, "result should contain no errors")
  end

  def test_get_address
    result = @client.get_address(some_address_name, DEFAULT_REGION)

    assert_equal("RESERVED", result.status, "request should be successful")
    assert_includes(result.name, some_address_name, "resulting address should have expected name")
  end

  def test_list_address
    # Let's create at least one address so there's something to view
    known_address = new_address_name
    wait_until_complete { @client.insert_address(known_address, DEFAULT_REGION) }

    result = @client.list_addresses(DEFAULT_REGION)
    assert_operator(result.items.size, :>, 0, "address count should be positive")
    assert_includes(result.items.map(&:name), known_address, "pre-existing address should be present")
  end

  def test_delete_address
    # Create something to delete
    address_to_delete = new_address_name
    wait_until_complete { @client.insert_address(address_to_delete, DEFAULT_REGION) }

    result = wait_until_complete { @client.delete_address(address_to_delete, DEFAULT_REGION) }

    assert_nil(result.error, "result should contain no errors")

    assert_raises(Google::Apis::ClientError) do
      @client.get_address(address_to_delete, DEFAULT_REGION)
    end
  end

  def test_list_aggregated_addresses
    @client.get_address(some_address_name, DEFAULT_REGION)
    result = @client.list_aggregated_addresses

    assert_operator(result.items.size, :>, 0, "address count should be positive")
    assert_includes(result.items.keys, "global", "'items' subset should contain global keyword")
  end
end
