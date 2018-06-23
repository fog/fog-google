require "helpers/integration_test_helper"
require "integration/factories/sql_v1_instances_factory"

class TestSQLV1Instances < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google[:sql].instances
    @factory = SqlV1InstancesFactory.new(namespaced_name)
  end

  def test_update
    instance = @factory.create

    settings_version = instance.settings_version
    labels = {
      :foo => "bar"
    }
    instance.settings[:user_labels] = labels
    instance.save

    updated = @subject.get(instance.name)
    assert_equal(labels, updated.settings[:user_labels])
    assert_operator(updated.settings_version, :>, settings_version)
  end

  def test_default_settings
    instance = @factory.create
    assert_equal([], instance.ssl_certs, "new instance should have 0 initial ssl certs")
  end
end
