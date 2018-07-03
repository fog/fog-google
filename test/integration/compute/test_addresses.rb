require "helpers/integration_test_helper"
require "integration/factories/addresses_factory"

class TestAddresses < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].addresses
    @factory = AddressesFactory.new(namespaced_name)

    # Example for testing collection get methods
    # Instantiating once to save time
    @example = @factory.create
  end

  def test_bad_get
    assert_nil @subject.get("bad-name", TEST_REGION)
  end

  def test_addresses_get_address_by_ip
    found = @subject.get_by_ip_address(@example.address)

    assert_equal(@example.name, found.name, "address should have same name")
    assert_equal(@example.address, found.address, "addresses should match")
  end

  def test_addresses_get_address_by_name
    found = @subject.get_by_name(@example.name)

    assert_equal(@example.name, found.name, "address should have same name")
    assert_equal(@example.address, found.address, "addresses should match")
  end

  def test_addresses_get_by_ip_address_or_name
    # Ensure we find the same addresses through both codepaths
    with_name = @subject.get_by_ip_address_or_name(@example.name)
    with_ip = @subject.get_by_ip_address_or_name(@example.address)

    assert_equal(@example.name, with_name.name, "address should have same name")
    assert_equal(@example.address, with_name.address, "addresses should match")

    assert_equal(@example.name, with_ip.name, "address should have same name")
    assert_equal(@example.address, with_ip.address, "addresses should match")
  end

  def test_addresses_in_use
    assert_equal(false, @example.in_use?, "example address should not be in use")
  end
end
