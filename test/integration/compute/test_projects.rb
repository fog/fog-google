require "helpers/integration_test_helper"

class TestProjects < FogIntegrationTest
  def setup
    @subject = Fog::Compute[:google].projects
  end

  def test_get
    assert @subject.get(TEST_PROJECT)
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
