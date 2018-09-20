require "helpers/integration_test_helper"

class TestOperations < FogIntegrationTest
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

  def test_zone_scoped_all
    subject_list = @subject.all
    scoped_subject_list = @subject.all(zone: TEST_ZONE)

    # Assert that whatever .all(scope) returns is a subset of .all
    assert(scoped_subject_list.all? { |x| subject_list.include? x },
           "Output of @subject.all(zone:#{TEST_ZONE}) must be a subset of @subject.all")
  end

  def test_region_scoped_all
    subject_list = @subject.all
    scoped_subject_list = @subject.all(region: TEST_REGION)

    # Assert that whatever .all(scope) returns is a subset of .all
    assert(scoped_subject_list.all? { |x| subject_list.include? x },
           "Output of @subject.all(region:#{TEST_REGION}) must be a subset of @subject.all")
  end

  def test_bad_get
    assert_nil @subject.get("bad-name")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
