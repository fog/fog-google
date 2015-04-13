module TestCollection
  # this should be reimplemented in the subject's TestClass if the subject has required params
  def params
    {}
  end

  def test_new_save_create_all_identity_get_destroy
    instance_one = @subject.new(params)
    instance_one.save
    instance_two = @subject.create(params)

    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), instance_one.identity
    assert_includes @subject.all.map(&:identity), instance_two.identity

    assert_equal instance_one.identity, @subject.get(instance_one.identity).identity
    assert_equal instance_two.identity, @subject.get(instance_two.identity).identity

    instance_one.destroy
    instance_two.destroy

    Fog.wait_for { !@subject.all.map(&:identity).include? instance_one.identity }
    Fog.wait_for { !@subject.all.map(&:identity).include? instance_two.identity }
  end

  def test_has_no_identity_if_it_has_not_been_persisted
    assert_nil @subject.get(@subject.new(params).identity)
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
