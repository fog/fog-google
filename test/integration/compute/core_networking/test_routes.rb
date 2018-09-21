require "helpers/integration_test_helper"

class TestRoutes < FogIntegrationTest
  def setup
    @subject = Fog::Compute[:google].routes
  end

  def test_all
    assert_operator(@subject.all.size, :>=, 2,
                    "Number of all routes should be greater or equal than 2 - default GW and default routes")
  end

  def test_get
    @subject.all do |route|
      refute_nil @subject.get(route.name)
    end
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
