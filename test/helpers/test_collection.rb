require "helpers/use_vcr"

module TestCollection
  include UseVCR

  # this should be reimplemented in the subject's TestClass if the subject has required params
  def params
    {}
  end

  def test_new_save_lifecycle
    instance = @subject.new(params)
    instance.save
    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), instance.identity
    assert_equal instance.identity, @subject.get(instance.identity).identity
    instance.destroy
    Fog.wait_for { !@subject.all.map(&:identity).include? instance.identity }
  end

  def test_create_lifecycle
    instance = @subject.create(params)
    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), instance.identity
    assert_equal instance.identity, @subject.get(instance.identity).identity
    instance.destroy
    Fog.wait_for { !@subject.all.map(&:identity).include? instance.identity }
  end

  def test_has_no_identity_if_it_has_not_been_persisted
    assert_nil @subject.get(@subject.new(params).identity)
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
