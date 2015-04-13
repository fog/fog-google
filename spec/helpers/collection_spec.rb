module Fog::CollectionSpec
  extend Minitest::Spec::DSL

  # this should be reimplemented in the subject's spec if the subject has required params
  def params
    {}
  end

  it "can do ::new, #save, ::create, #all, #identity, ::get, and #destroy" do
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

    Fog.wait_for { !subject.all.map(&:identity).include? instance_one.identity }
    Fog.wait_for { !subject.all.map(&:identity).include? instance_two.identity }

    assert_nil subject.get(subject.new(params).identity)
  end

  it "is Enumerable" do
    assert_respond_to subject, :each
  end
end
