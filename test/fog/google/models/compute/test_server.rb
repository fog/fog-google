require "minitest_helper"
require "helpers/test_collection"

class TestServer < MiniTest::Test
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

  # XXX this test is currently broken with VCR
  # we need to figure out a way to get ssh working with VCR, or work around the need to ssh.  The problem is with this line:
  #     https://github.com/fog/fog-core/blob/master/lib/fog/compute/models/server.rb#L93
  # where it returns false because the ssh times out,

  # TODO or maybe because of some other error!?

  # def test_bootstrap_ssh_destroy
  #   instance = @subject.bootstrap

  #   assert instance.ready?
  #   instance.wait_for { sshable? }
  #   assert_match /Linux/, instance.ssh("uname").first.stdout
  #   assert_equal instance.destroy.operation_type, "delete"
  # end
end
