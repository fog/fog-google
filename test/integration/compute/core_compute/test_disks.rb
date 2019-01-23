require "helpers/integration_test_helper"
require "integration/factories/disks_factory"

class TestDisks < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].disks
    @factory = DisksFactory.new(namespaced_name)
  end

  def test_get_as_configs
    disk = @factory.create
    disk.wait_for { ready? }

    example = disk.get_as_boot_disk
    config = { :auto_delete => false,
               :boot => true,
               :source => disk.self_link,
               :mode => "READ_WRITE",
               :type => "PERSISTENT" }
    assert_equal(example, config)

    example_with_params = disk.get_as_boot_disk(false, true)
    config_with_params = { :auto_delete => true,
                           :boot => true,
                           :source => disk.self_link,
                           :mode => "READ_ONLY",
                           :type => "PERSISTENT" }
    assert_equal(example_with_params, config_with_params)
  end

  def test_create_snapshot
    disk = @factory.create
    disk.wait_for { ready? }

    snapshot = disk.create_snapshot("fog-test-snapshot")

    assert(snapshot.is_a?(Fog::Compute::Google::Snapshot),
           "Resulting snapshot should be a snapshot object.")

    assert_raises(ArgumentError) { snapshot.set_labels(["bar", "test"]) }

    snapshot.set_labels(foo: "bar", fog: "test")

    assert_equal(snapshot.labels[:foo], "bar")
    assert_equal(snapshot.labels[:fog], "test")

    # Clean up the snapshot
    operation = snapshot.destroy
    operation.wait_for { ready? }
  end
end
