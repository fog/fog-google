require "minitest_helper"
require "helpers/test_collection"
require "factories/http_health_checks_factory"

class TestHttpHealthCheck < MiniTest::Test
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].http_health_checks
    @factory = HttpHealthChecksFactory.new
  end
end
