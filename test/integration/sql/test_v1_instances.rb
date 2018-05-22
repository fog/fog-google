require "helpers/integration_test_helper"
require "integration/factories/sql_v1_factory"

class TestSQLV1Instances < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google[:sql].instances
    @factory = SqlV1Factory.new(namespaced_name)
  end

end