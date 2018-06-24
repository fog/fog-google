require "helpers/integration_test_helper"
require "integration/factories/servers_factory"

class TestServers < FogIntegrationTest
  include TestCollection

  # Cleanup is handled by TestCollection
  def setup
    @subject = Fog::Compute[:google].servers
    @factory = ServersFactory.new(namespaced_name)
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
      # Name is set this way so it will be cleaned up by CollectionFactory
      # Public_key_path is set to avoid stubbing out File.exist?
      server = @subject.bootstrap(:name => "#{CollectionFactory::PREFIX}-#{Time.now.to_i}",
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
    end
  end
end
