require "helpers/integration_test_helper"
require "integration/factories/addresses_factory"
require "integration/factories/servers_factory"

class TestAddresses < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].addresses
    @servers = Fog::Compute[:google].servers
    @factory = AddressesFactory.new(namespaced_name)
  end

  def teardown
    # Clean up the server created by calling factory cleanup method
    # TODO: Think about doing cleanup better as this needs to be invoked only once
    ServersFactory.new(namespaced_name).cleanup
    super
  end

  # TODO: think about simplifying this.
  # Ideally factory should permit to be called with special parameters.
  def test_run_instance
    address = @factory.create
    params = { :name => "#{CollectionFactory::PREFIX}-#{Time.new.to_i}",
               :machine_type => "f1-micro",
               :zone => TEST_ZONE,
               :disks => [
                 :boot => true,
                 :auto_delete => true,
                 :initialize_params => {
                   :source_image => "projects/debian-cloud/global/images/family/debian-8"
                 }
               ],
               :external_ip => address.address }
    server = @servers.create(params)

    assert_equal(
      address.address,
      server.network_interfaces[0][:access_configs][0][:nat_ip],
      "Created server should have the correct address after initialization"
    )

    assert_equal(
      "IN_USE",
      @subject.get(address.name, TEST_REGION).status,
      "Address should now be in use"
    )
  end

  def test_bad_get
    assert_nil @subject.get("bad-name", TEST_REGION)
  end

  def test_valid_range
    address = @factory.create

    octet = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
    re = /\A#{octet}\.#{octet}\.#{octet}\.#{octet}\z/

    assert_match(re, address.address,
                 "Adress should be a valid ipv4 address")
  end

  def test_addresses_get_address_by_ip
    address = @factory.create
    found = @subject.get_by_ip_address(address.address)

    assert_equal(address.name, found.name, "address should have same name")
    assert_equal(address.address, found.address, "addresses should match")
  end

  def test_addresses_get_address_by_name
    address = @factory.create
    found = @subject.get_by_name(address.name)

    assert_equal(address.name, found.name, "address should have same name")
    assert_equal(address.address, found.address, "addresses should match")
  end

  def test_addresses_get_by_ip_address_or_name
    # Ensure we find the same addresses through both codepaths
    address = @factory.create
    with_name = @subject.get_by_ip_address_or_name(address.name)
    with_ip = @subject.get_by_ip_address_or_name(address.address)

    assert_equal(address.name, with_name.name, "address should have same name")
    assert_equal(address.address, with_name.address, "addresses should match")

    assert_equal(address.name, with_ip.name, "address should have same name")
    assert_equal(address.address, with_ip.address, "addresses should match")
  end

  def test_addresses_in_use
    address = @factory.create
    assert_equal(false, address.in_use?, "example address should not be in use")
  end
end
