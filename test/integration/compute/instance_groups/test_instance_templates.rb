require "helpers/integration_test_helper"
require "integration/factories/instance_template_factory"

class TestInstanceTemplates < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Google::Compute.new.instance_templates
    @factory = InstanceTemplateFactory.new(namespaced_name)
  end
end
