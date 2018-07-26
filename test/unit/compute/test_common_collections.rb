require "helpers/test_helper"
require "pry"

class UnitTestCollections < MiniTest::Test
  def setup
    Fog.mock!

    @client = Fog::Compute.new(provider: "google",
                               google_project: "foo")

    # Projects do not have a "list" method in compute API
    exceptions = [Fog::Compute::Google::Projects]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class).to_a

    @collections = descendants.select { |d| d.name.match /Fog::Compute::Google/ } - exceptions
  end

  def teardown
    Fog.unmock!
  end

  def test_common_methods
    # This tests whether Fog::Compute::Google collections have common lifecycle methods
    @collections.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:all), "#{klass} should have an .all method"
      assert obj.respond_to?(:get), "#{klass} should have a .get method"
      assert obj.respond_to?(:each), "#{klass} should behave like Enumerable"
    end
  end

  def test_collection_get_arguments
    @collections.each do |klass|
      obj = klass.new
      assert_operator(obj.method(:get).arity, :<=, 1,
                      "#{klass} should have at most 1 required parameter in get()")
    end
  end
end
