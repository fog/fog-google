require "minitest_helper"
require "helpers/test_collection"
require "factories/images_factory"

class TestImages < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].images
    @factory = ImagesFactory.new(namespaced_name)
  end

  def teardown
    @factory.cleanup
  end
end
