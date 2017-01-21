require "helpers/integration_test_helper"
require "securerandom"

class TestComputeNetworksCollection < FogIntegrationTest
  DEFAULT_REGION = "us-central1".freeze
  DEFAULT_ZONE = "us-central1-b".freeze
  RESOURCE_PREFIX = "fog-test-networkscol".freeze

  # Ensure we clean up any created resources
  Minitest.after_run do
    client = Fog::Compute::Google.new
    client.networks.each { |a| a.destroy if a.name.start_with?(RESOURCE_PREFIX) }
    client.servers.each { |s| s.destroy if s.name.start_with?(RESOURCE_PREFIX) }
  end

  def test_network_workflow
    client = Fog::Compute::Google.new

    my_network_name = new_resource_name
    # An address can be created by specifying a name and a region
    my_network = client.networks.create(
      :name => my_network_name,
      :ipv4_range => "10.240.#{rand(255)}.0/24"
    )

    assert_equal(my_network_name, my_network.name, "My network should have the provided name")

    # It should also be visible when listing addresses
    assert_includes(client.networks.all.map(&:name), my_network_name)

    # Be aware that although the address resource is created, it might not yet
    # have an ip address. You can poll until the address has been assigned.
    my_network.wait_for { !my_network.ipv4_range.nil? }
    assert_match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}/,
                 my_network.ipv4_range,
                 "My address's address should have a valid ipv4 address")

    # Now that we have an address, we can create a server using the static ip
    my_server = client.servers.create(
      :name => new_resource_name,
      :machine_type => "f1-micro",
      :zone_name => DEFAULT_ZONE,
      :disks => [
        :boot => true,
        :autoDelete => true,
        :initializeParams => {
          :sourceImage => "projects/debian-cloud/global/images/family/debian-8"
        }
      ],
      :network => my_network
    )
    my_server.wait_for { provisioning? }

    # We need to verify that the network has been correctly assigned
    assert_equal(
      my_network.self_link,
      my_server.network_interfaces[0]["network"],
      "My created server should have the network specified as the network"
    )

    # Access config needs to be correctly populated
    assert_equal(
      "ONE_TO_ONE_NAT",
      my_server.network_interfaces[0]["accessConfigs"][0]["type"],
      "Access config type matches the correct default"
    )

    assert_equal(
      "External NAT",
      my_server.network_interfaces[0]["accessConfigs"][0]["name"],
      "Access config name matches the correct default"
    )
  end

  def new_resource_name
    "#{RESOURCE_PREFIX}-#{SecureRandom.uuid}"
  end
end
