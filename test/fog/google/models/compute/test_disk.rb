require "minitest_helper"
require "helpers/test_collection"

class TestDisk < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].disks
  end

  def params
    {:name => create_test_name,
     :zone_name => TEST_ZONE,
     :size_gb => TEST_SIZE_GB}
  end
end
