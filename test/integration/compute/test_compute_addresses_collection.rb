require "helpers/integration_test_helper"
require "securerandom"

class TestComputeAddressesCollection < FogIntegrationTest
  DEFAULT_REGION = "us-central1".freeze
  DEFAULT_ZONE = "us-central1-b".freeze
  RESOURCE_PREFIX = "fog-test-addresscol".freeze

  # Ensure we clean up any created resources
  Minitest.after_run do
    client = Fog::Compute::Google.new
    client.addresses.each { |a| a.destroy if a.name.start_with?(RESOURCE_PREFIX) }
    client.servers.each { |s| s.destroy if s.name.start_with?(RESOURCE_PREFIX) }
  end

  def test_address_workflow
    client = Fog::Compute::Google.new

    my_address_name = new_resource_name
    # An address can be created by specifying a name and a region
    my_address = client.addresses.create(
      :name => my_address_name,
      :region => DEFAULT_REGION
    )
    # TODO: Shouldn't this be returning an operation object that we have to explicitly wait for?
    assert_equal(my_address_name, my_address.name, "My address should have the provided name")
    assert_equal("RESERVED", my_address.status, "My address should not be in use")

    # It should also be visible when listing addresses
    assert_includes(client.addresses.all.map(&:name), my_address_name)

    # Be aware that although the address resource is created, it might not yet
    # have an ip address. You can poll until the address has been assigned.
    my_address.wait_for { !my_address.address.nil? }
    assert_match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
                 my_address.address,
                 "My address's address should have a valid ipv4 address")

    # Now that we have an address, we can create a server using the static ip
    my_server = client.servers.create(
      :name => new_resource_name,
      :machine_type => "f1-micro",
      :zone => client.zones.get(DEFAULT_ZONE).self_link,
      :disks => [
        :boot => true,
        :auto_delete => true,
        :initialize_params => {
          :source_image => "projects/debian-cloud/global/images/family/debian-8"
        }
      ],
      :external_ip => my_address.address
    )
    my_server.wait_for { provisioning? }

    # And verify that it's correctly assigned
    assert_equal(
      my_address.address,
      my_server.network_interfaces[0][:access_configs][0][:nat_ip],
      "My created server should have the same ip as my address"
    )

    # If we look up the address again by name, we should see that it is now
    # in use
    assert_equal(
      "IN_USE",
      client.addresses.get(my_address_name, DEFAULT_REGION).status,
      "Address should now be in use"
    )
  end

  def new_resource_name
    "#{RESOURCE_PREFIX}-#{SecureRandom.uuid}"
  end
end
