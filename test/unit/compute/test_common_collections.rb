require "helpers/test_helper"

class UnitTestCollections < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Compute.new(:provider => "Google", :google_project => "foo")

    # Top-level ancestors we do not dest
    common_ancestors = [Fog::Collection, Fog::Association, Fog::PagedCollection]
    # Projects do not have a "list" method in compute API
    exceptions = [Fog::Compute::Google::Projects]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class).to_a

    @collections = descendants - common_ancestors - exceptions
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
end
