require "minitest_helper"
require "helpers/test_collection"
require "factories/target_pools_factory"

class TestTargetPool < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].target_pools
    @factory = TargetPoolsFactory.new
  end

  def teardown
    @factory.cleanup
  end
end
