require "helpers/integration_test_helper"
require "integration/factories/instance_template_factory"

class TestInstanceTemplates < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].instance_templates
    @factory = InstanceTemplateFactory.new(namespaced_name)
  end
end
