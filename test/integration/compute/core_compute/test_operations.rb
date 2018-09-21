require "helpers/integration_test_helper"

class TestRoutes < FogIntegrationTest
  def setup
    @subject = Fog::Compute[:google].operations
  end

  def test_all
    # TODO: what if this test runs first on a brand new project?
    assert_operator(@subject.all.size, :>=, 2,
                    "There should be at least 2 operations in the project")
  end

  def test_get
    @subject.all do |operation|
      refute_nil @subject.get(operation.name)
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
