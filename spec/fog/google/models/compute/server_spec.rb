require "minitest_helper"
require "helpers/collection_spec"

describe Fog::Compute[:google].servers do
  subject { Fog::Compute[:google].servers }

  before do
    @disks = []
  end

  after do
    @disks.each { |disk| disk.destroy }
  end

  def params
    @disks << test_disk = create_test_disk
    params = {:name => test_name,
              :zone_name => TEST_ZONE,
              :machine_type => TEST_MACHINE_TYPE,
              :disks => [test_disk]}
  end

  include Fog::CollectionSpec

  it "can do ::bootstrap, #ssh, and #destroy" do
    instance = subject.bootstrap

    assert instance.ready?
    instance.wait_for { sshable? }
    assert_match /Linux/, instance.ssh("uname").first.stdout
    assert_equal instance.destroy.operation_type, "delete"
  end
end
