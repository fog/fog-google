# TODO this should be more comprehensive and/or actually come from `fog` or `fog-core`
def model_spec(collection, param_generator)
  it "can do ::new, #save, ::create, #all, #identity, ::get, and #destroy" do
    instance_one = collection.new(param_generator.call)
    instance_one.save
    instance_two = collection.create(param_generator.call)

    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes collection.all.map(&:identity), instance_one.identity
    assert_includes collection.all.map(&:identity), instance_two.identity

    assert_equal instance_one.identity, collection.get(instance_one.identity).identity
    assert_equal instance_two.identity, collection.get(instance_two.identity).identity

    instance_one.destroy
    instance_two.destroy

    assert_nil collection.get(collection.new(param_generator.call).identity)
  end

  it "is Enumerable" do
    assert_respond_to collection, :each
  end
end
