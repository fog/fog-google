require "helpers/test_helper"

class UnitTestDNSCollections < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::DNS.new(provider: "google",
                           google_project: "foo")

    # Exceptions that do not pass test_common_methods:
    #
    # DNS Projects API does not support 'list', so 'all' method is not possible
    @common_methods_exceptions = [Fog::Google::DNS::Projects]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class)

    @collections = descendants.select { |d| d.name.match(/Fog::Google::DNS/) }
  end

  def teardown
    Fog.unmock!
  end

  # This tests whether Fog::Google::Compute collections have common lifecycle methods
  def test_common_methods
    subjects = @collections - @common_methods_exceptions
    subjects.each do |klass|
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
