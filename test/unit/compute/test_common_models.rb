require "helpers/test_helper"

class UnitTestModels < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Compute.new(:provider => "Google", :google_project => "foo")

    # Top-level ancestors we do not test
    common_ancestors = [Fog::Model, Fog::Compute::Server]
    # Do not test models that do not have a create method in API
    exceptions = [ Fog::Compute::Google::MachineType,
                   Fog::Compute::Google::Region,
                   Fog::Compute::Google::DiskType,
                   Fog::Compute::Google::Operation,
                   Fog::Compute::Google::Zone,
                   Fog::Compute::Google::Snapshot,
                   Fog::Compute::Google::Project ]
    # Enumerate all descendants of Fog::Model
    descendants = ObjectSpace.each_object(Fog::Model.singleton_class).to_a

    @models = descendants - common_ancestors - exceptions
  end

  def teardown
    Fog.unmock!
  end

  def test_common_methods
    # This tests whether Fog::Compute::Google models have common lifecycle methods
    @models.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:save), "#{klass} should have a .save method"
      assert obj.respond_to?(:destroy), "#{klass} should have a .destroy method"
    end
  end
end
