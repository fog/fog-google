require "helpers/integration_test_helper"
require "integration/factories/servers_factory"
require "integration/factories/disks_factory"
require "resolv"

class TestServers < FogIntegrationTest
  include TestCollection

  # Cleanup is handled by TestCollection
  def setup
    @subject = Fog::Compute[:google].servers
    @factory = ServersFactory.new(namespaced_name)
    @servers = ServersFactory.new(namespaced_name)
    @disks = DisksFactory.new(namespaced_name)
  end

  def teardown
    # Clean up the server resources used in testing
    @servers.cleanup
    super
  end

  def test_set_metadata
    server = @factory.create
    server.wait_for { ready? }
    server.set_metadata({ "foo" => "bar", "baz" => "foo" }, false)
    assert_equal [{ :key => "foo", :value => "bar" },
                  { :key => "baz", :value => "foo" }], server.metadata[:items]
  end

  def test_bootstrap
    key = "ssh-rsa IAMNOTAREALSSHKEYAMA== user@host.subdomain.example.com"
    user = "username"

    File.stub :read, key do
      # XXX Small hack - name is set this way so it will be cleaned up by CollectionFactory
      # Bootstrap is special so this is something that needs to be done only for this method
      # Public_key_path is set to avoid stubbing out File.exist?
      server = @subject.bootstrap(:name => "#{CollectionFactory.new(nil,namespaced_name).resource_name}",
                                  :username => user,
                                  :public_key_path => "foo")
      boot_disk = server.disks.detect { |disk| disk[:boot] }

      assert_equal("RUNNING", server.status, "Bootstrapped server should be running")
      assert_equal(key, server.public_key, "Bootstrapped server should have a public key set")
      assert_equal(user, server.username, "Bootstrapped server should have user set to #{user}")
      assert(boot_disk[:auto_delete], "Bootstrapped server should have disk set to autodelete")

      network_adapter = server.network_interfaces.detect { |x| x.has_key?(:access_configs) }

      refute_nil(network_adapter[:access_configs].detect { |x| x[:nat_ip] },
                 "Bootstrapped server should have an external ip by default")
    end
  end

  def test_bootstrap_fail
    # Pretend the ssh key does not exist
    File.stub :exist?, nil do
      assert_raises(Fog::Errors::Error) {
        # XXX Small hack - name is set this way so it will be cleaned up by CollectionFactory
        # Bootstrap is special so this is something that needs to be done only for this method
        @subject.bootstrap(:name => "#{CollectionFactory.new(nil,namespaced_name).resource_name}",
                           :public_key_path => nil)
      }
    end
  end

  def test_image_name
    server = @factory.create
    assert_equal(TEST_IMAGE, server.image_name.split("/")[-1])
  end

  def test_ip_address_methods
    # Create a server with ephemeral external IP address
    server = @factory.create(:network_interfaces => [{ :network => "global/networks/default",
                                                       :access_configs => [{
                                                         :name => "External NAT",
                                                         :type => "ONE_TO_ONE_NAT"
                                                       }] }])
    assert_match(Resolv::IPv4::Regex, server.public_ip_address,
                 "Server.public_ip_address should return a valid IP address")
    refute_empty(server.public_ip_addresses)
    assert_match(Resolv::IPv4::Regex, server.public_ip_addresses.pop)

    assert_match(Resolv::IPv4::Regex, server.private_ip_address,
                 "Server.public_ip_address should return a valid IP address")
    refute_empty(server.private_ip_addresses)
    assert_match(Resolv::IPv4::Regex, server.private_ip_addresses.pop)
  end

  def test_start_stop_reboot
    server = @factory.create

    server.stop
    server.wait_for { stopped? }

    assert server.stopped?

    server.start
    server.wait_for { ready? }

    assert server.ready?

    server.reboot
    server.wait_for { ready? }

    assert server.ready?
  end
end
