require "helpers/integration_test_helper"
require "integration/compute/addresses/addresses_shared"
require "helpers/client_helper"
require "securerandom"

class TestComputeAddressModels < TestComputeAddressShared
  def test_addresses_create
    address_name = new_address_name
    address = @client.addresses.create(
      :name => address_name,
      :region => DEFAULT_REGION
    )
    assert_equal(address_name, address.name, "address should have same name")
    assert_nil(address.users, "new address should have no users")
  end

  def test_addresses_get
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    assert_equal(some_address_name, address.name, "address should have same name")
  end

  def test_addresses_get_address_by_ip
    # Fetch a preexisting address to learn its IP
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    found = @client.addresses.get_by_ip_address(address.address)

    assert_equal(address.name, found.name, "address should have same name")
    assert_equal(address.address, found.address, "addresses should match")
  end

  def test_addresses_get_address_by_name
    # Fetch a preexisting address to learn its IP
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    found = @client.addresses.get_by_name(some_address_name)

    assert_equal(address.name, found.name, "address should have same name")
    assert_equal(address.address, found.address, "addresses should match")
  end

  def test_addresses_get_by_ip_address_or_name
    # Fetch a preexisting address to learn its IP
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    # Ensure we find the same addresses through both codepaths
    with_name = @client.addresses.get_by_ip_address_or_name(some_address_name)
    with_ip = @client.addresses.get_by_ip_address_or_name(address.address)

    assert_equal(address.name, with_name.name, "address should have same name")
    assert_equal(address.address, with_name.address, "addresses should match")

    assert_equal(with_name.name, with_ip.name, "address should have same name")
    assert_equal(with_name.address, with_ip.address, "addresses should match")
  end

  def test_addresses_all
    # Fetch a preexisting address to learn its IP
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    found = @client.addresses.all

    assert_operator(found.size, :>, 0, "address count should be positive")
    assert_includes(found.map(&:name), address.name, "pre-existing address should be present")
  end

  def test_addresses_destroy
    # Make a existing address to delete
    address_name = new_address_name
    address = @client.addresses.create(
      :name => address_name,
      :region => DEFAULT_REGION
    )

    # Force synchronous for easier testing
    address.destroy(false)

    assert_raises(Google::Apis::ClientError) do
      @client.get_address(address_name, DEFAULT_REGION)
    end
  end

  def test_addresses_in_use
    # Make a existing address to delete
    address = @client.addresses.get(some_address_name, DEFAULT_REGION)

    assert_equal(false, address.in_use?, "address should not be in use")
  end

  def test_address_associate
    # TODO: implement when servers are implemented @everlag
    skip
  end

  def test_address_disassociate
    # TODO: implement when servers are implemented @everlag
    skip
  end

  def test_address_server_set
    # TODO: implement when servers are implemented @everlag
    skip
  end
end
