require "minitest_helper"
require "helpers/model_helper"

def server_param_generator
  Proc.new do
    {:name => test_name("server"),
     :zone_name => TEST_ZONE,
     :machine_type => "n1-standard-1",
     :disks => [create_test_disk]}
  end
end

describe Fog::Compute[:google].servers do
  model_spec(Fog::Compute[:google].servers, server_param_generator)

  it "can do ::bootstrap, #ssh, and #destroy" do
    instance = Fog::Compute[:google].servers.bootstrap

    assert instance.ready?
    instance.wait_for { sshable? }
    assert_match /Linux/, instance.ssh("uname").first.stdout
    assert_equal instance.destroy.operation_type, "delete"
  end
end
