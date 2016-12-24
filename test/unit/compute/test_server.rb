require "helpers/test_helper"
require File.expand_path("../../../../lib/fog/compute/google/models/server", __FILE__)

class UnitTestServer < MiniTest::Test
  def test_metadata_uses_deprecated_sshKeys_if_exists
    server = Fog::Compute::Google::Server.new(:metadata => { "sshKeys" => "existing_user:existing_key" })
    server.add_ssh_key("my_username", "my_key")

    assert_match(/my_username/, server.metadata["sshKeys"])
    assert_match(/my_key/, server.metadata["sshKeys"])
  end

  def test_add_ssh_key_uses_ssh_keys_by_default
    server = Fog::Compute::Google::Server.new
    server.add_ssh_key("my_username", "my_key")

    assert_match(/my_username/, server.metadata["ssh-keys"])
    assert_match(/my_key/, server.metadata["ssh-keys"])
  end
end
