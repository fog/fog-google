require "helpers/test_helper"
require "pry"

class UnitTestSQLCollections < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Google::SQL.new

    # SQL Users API doesn't have a get method
    # SQL Flags API has only a 'list' method
    exceptions = [Fog::Google::SQL::Users,
                  Fog::Google::SQL::Tiers,
                  Fog::Google::SQL::Flags]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class)

    @collections = descendants.select { |d| d.name.match /Fog::Google::SQL/ } - exceptions
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
    # TODO: Fixture for #352
    skip
    @collections.each do |klass|
      obj = klass.new
      assert_operator(obj.method(:get).arity, :<=, 1,
                      "#{klass} should have at most 1 required parameter in get()")
    end
  end
end
