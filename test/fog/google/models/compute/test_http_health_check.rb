require "minitest_helper"
require "helpers/test_collection"

class TestHttpHealthCheck < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].http_health_checks
  end

  def params
    {:name => create_test_name}
  end
end
