require "helpers/integration_test_helper"
require "integration/factories/images_factory"

class TestImages < FogIntegrationTest
  include TestCollection

  def setup
    @subject = Fog::Compute[:google].images
    @factory = ImagesFactory.new(namespaced_name)
  end

  def test_get_specific_image
    image = @subject.get(TEST_IMAGE)
    refute_nil(image, "Images.get(#{TEST_IMAGE}) should not return nil")
    assert_equal(image.family, TEST_IMAGE_FAMILY)
    assert_equal(image.project, TEST_IMAGE_PROJECT)
  end

  def test_get_specific_image_from_project
    image = @subject.get(TEST_IMAGE,TEST_IMAGE_PROJECT)
    refute_nil(image, "Images.get(#{TEST_IMAGE}) should not return nil")
    assert_equal(image.family, TEST_IMAGE_FAMILY)
    assert_equal(image.project, TEST_IMAGE_PROJECT)
  end

  def test_get_from_family
    image = @subject.get_from_family(TEST_IMAGE_FAMILY)
    refute_nil(image,"Images.get_from_family(#{TEST_IMAGE_FAMILY}) should not return nil")
    assert_equal(image.family, TEST_IMAGE_FAMILY)
    assert_equal(image.project, TEST_IMAGE_PROJECT)
  end
end
