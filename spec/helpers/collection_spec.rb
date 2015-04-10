module Fog::CollectionSpec
  extend Minitest::Spec::DSL

  it "can do ::new, #save, ::create, #all, #identity, ::get, and #destroy" do
    puts subject
    instance_one = subject.new(params)
    instance_one.save
    instance_two = subject.create(params)

    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes subject.all.map(&:identity), instance_one.identity
    assert_includes subject.all.map(&:identity), instance_two.identity

    assert_equal instance_one.identity, subject.get(instance_one.identity).identity
    assert_equal instance_two.identity, subject.get(instance_two.identity).identity

    instance_one.destroy
    instance_two.destroy

    assert_nil subject.get(subject.new(params).identity)
  end

  it "is Enumerable" do
    assert_respond_to subject, :each
  end
end
