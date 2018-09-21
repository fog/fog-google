require "helpers/test_helper"

class UnitTestMonitoringCollections < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Monitoring.new(provider: "google",
                                  google_project: "foo")

    # Exceptions that do not pass test_common_methods:
    #
    # TimeSeries API has no 'get' method
    @common_method_exceptions = [Fog::Google::Monitoring::TimeseriesCollection]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class).to_a

    @collections = descendants.select { |d| d.name.match(/Fog::Google::Monitoring/) }
  end

  def teardown
    Fog.unmock!
  end

  # This tests whether Fog::Compute::Google collections have common lifecycle methods
  def test_common_methods
    subjects = @collections - @common_method_exceptions

    subjects.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:all), "#{klass} should have an .all method"
      assert obj.respond_to?(:get), "#{klass} should have a .get method"
      assert obj.respond_to?(:each), "#{klass} should behave like Enumerable"
    end
  end

  def test_collection_get_arguments
    @collections.each do |klass|
      obj = klass.new
      if obj.respond_to?(:get)
        assert_operator(obj.method(:get).arity, :<=, 1,
                        "#{klass} should have at most 1 required parameter in get()")
      end
    end
  end
end
