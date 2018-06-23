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
      server = @subject.bootstrap(:name => "#{CollectionFactory::PREFIX}-#{Time.now.to_i}",
                                  :username => user)
      boot_disk = server.disks.detect { |disk| disk[:boot] }

      assert_equal(server.status, "RUNNING", "Bootstrapped server should be running")
      assert_equal(server.public_key, key, "Bootstrapped server should have a public key set")
      assert_equal(server.username, user, "Bootstrapped server should have a user set")
      assert(boot_disk[:auto_delete], "Bootstrapped server should have disk set to autodelete")
    end
  end
end
