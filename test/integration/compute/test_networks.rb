require "helpers/integration_test_helper"
require "integration/factories/networks_factory"
require "integration/factories/servers_factory"

class TestNetworks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].networks
    @servers = Fog::Compute[:google].servers
    @factory = NetworksFactory.new(namespaced_name)
  end

  def teardown
    # Clean up the server created by calling factory cleanup method
    # TODO: Think about doing cleanup better as this needs to be invoked only once
    ServersFactory.new(namespaced_name).cleanup
    super
  end

  def test_valid_range
    network = @factory.create

    octet = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
    netmask = /(\d{1}|1[0-9]|2[0-9]|3[0-2])/
    re = /\A#{octet}\.#{octet}\.#{octet}\.#{octet}\/#{netmask}\z/

    assert_match(re, network.ipv4_range,
                 "Network range should be valid")
  end

  # TODO: think about simplifying this
  # Ideally factory should permit to be called with special parameters.
  def test_run_instance
    network = @factory.create
    params = { :name => "#{CollectionFactory::PREFIX}-#{Time.new.to_i}",
               :machine_type => "f1-micro",
               :zone => TEST_ZONE,
               :disks => [
                 :boot => true,
                 :auto_delete => true,
                 :initialize_params => {
                   :source_image => "projects/debian-cloud/global/images/family/debian-9"
                 }
               ],
               :network_interfaces => [network.get_as_interface_config] }
    server = @servers.create(params)

    assert_equal(
      network.self_link,
      server.network_interfaces[0][:network],
      "Created server should have the network specified on boot"
    )
  end
end
