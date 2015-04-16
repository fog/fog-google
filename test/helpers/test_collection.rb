require "helpers/use_vcr"

module TestCollection
  include UseVCR

  # Anything that includes TestCollection must, during setup, assign @subject and @factory, where
  #   @subject is the collection under test, (e.g. Fog::Compute[:google].servers)
  #   @factory is a CollectionFactory

  def test_new_save_lifecycle
    instance = @subject.new(@factory.params)
    instance.save
    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), instance.identity
    assert_equal instance.identity, @subject.get(instance.identity).identity
    instance.destroy
    Fog.wait_for { !@subject.all.map(&:identity).include? instance.identity }
  end

  def test_create_lifecycle
    instance = @subject.create(@factory.params)
    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), instance.identity
    assert_equal instance.identity, @subject.get(instance.identity).identity
    instance.destroy
    Fog.wait_for { !@subject.all.map(&:identity).include? instance.identity }
  end

  def test_has_no_identity_if_it_has_not_been_persisted
    assert_nil @subject.get(@subject.new(@factory.params).identity)
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
