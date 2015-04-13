require "minitest_helper"
require "helpers/test_collection"

class ServerTest < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].servers

    @disks = []
  end

  def teardown
    @disks.each { |disk| disk.destroy }
  end

  def params
    @disks << test_disk = create_test_disk
    params = {:name => create_test_name,
              :zone_name => TEST_ZONE,
              :machine_type => TEST_MACHINE_TYPE,
              :disks => [test_disk]}
  end

  def test_bootstrap_ssh_destroy
    instance = @subject.bootstrap

    assert instance.ready?
    instance.wait_for { sshable? }
    assert_match /Linux/, instance.ssh("uname").first.stdout
    assert_equal instance.destroy.operation_type, "delete"
  end
end
