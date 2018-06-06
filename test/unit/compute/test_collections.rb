require "helpers/test_helper"

class UnitTestCollections < MiniTest::Test

  def setup
    Fog.mock!
    @client = Fog::Compute.new(:provider => "Google")
    common_ancestors = [Fog::Collection, Fog::Association, Fog::PagedCollection]
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class).to_a

    @collections = descendants - common_ancestors
  end

  def test_common_methods
    # This tests whether Fog::Compute::Google collections have common lifecycle methods
    @collections.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:all), "#{klass} should respond to .all"
      assert obj.respond_to?(:get), "#{klass} should respond to .get"
      assert obj.respond_to?(:each), "#{klass} should be enumerable"
    end
  end
end