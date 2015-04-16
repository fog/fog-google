require "minitest_helper"
require "helpers/test_collection"
require "factories/disks_factory"

class TestDisks < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].disks
    @factory = DisksFactory.new
  end
end
