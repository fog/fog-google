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
end
