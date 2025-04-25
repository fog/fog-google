require "helpers/test_helper"

class UnitTestModels < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Compute.new(provider: "google",
                               google_project: "foo")

    # Do not test models that do not have a create method in API
    exceptions = [Fog::Google::Compute::MachineType,
                  Fog::Google::Compute::Region,
                  Fog::Google::Compute::DiskType,
                  Fog::Google::Compute::Operation,
                  Fog::Google::Compute::Zone,
                  Fog::Google::Compute::Snapshot,
                  Fog::Google::Compute::Project]
    # Enumerate all descendants of Fog::Model
    descendants = ObjectSpace.each_object(Fog::Model.singleton_class).to_a

    @models = descendants.select { |d| d.name.match(/Fog::Google::Compute/) } - exceptions
  end

  def teardown
    Fog.unmock!
  end

  def test_common_methods
    # This tests whether Fog::Google::Compute models have common lifecycle methods
    @models.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:save), "#{klass} should have a .save method"
      assert obj.respond_to?(:destroy), "#{klass} should have a .destroy method"
    end
  end
end
