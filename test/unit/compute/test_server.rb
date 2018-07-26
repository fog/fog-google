require "helpers/test_helper"

class UnitTestServer < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Compute.new(provider: "google",
                               google_project: "foo")
  end

  def teardown
    Fog.unmock!
  end

  def test_if_server_accepts_ssh_keys
    key = "ssh-rsa IAMNOTAREALSSHKEYAMA== user@host.subdomain.example.com"

    File.stub :read, key do
      server = Fog::Compute::Google::Server.new(
        :name => "foo",
        :machine_type => "bar",
        :disks => ["baz"],
        :zone => "foo",
        :public_key_path => key
      )
      assert_equal(server.public_key, key,
                   "Fog::Compute::Google::Server loads public_key properly")
    end
  end
end
