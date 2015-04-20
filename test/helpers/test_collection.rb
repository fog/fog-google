require "helpers/use_vcr"

module TestCollection
  include UseVCR

  # Anything that includes TestCollection must, during setup, assign @subject and @factory, where
  #   @subject is the collection under test, (e.g. Fog::Compute[:google].servers)
  #   @factory is a CollectionFactory

  def test_lifecycle
    one = @subject.new(@factory.params)
    one.save
    two = @subject.create(@factory.params)

    # XXX HACK compares identities
    # should be replaced with simple includes? when `==` is properly implemented in fog-core; see fog/fog-core#148
    assert_includes @subject.all.map(&:identity), one.identity
    assert_includes @subject.all.map(&:identity), two.identity

    assert_equal one.identity, @subject.get(one.identity).identity
    assert_equal two.identity, @subject.get(two.identity).identity

    one.destroy
    two.destroy

    Fog.wait_for { !@subject.all.map(&:identity).include? one.identity }
    Fog.wait_for { !@subject.all.map(&:identity).include? two.identity }
  end

  def test_has_no_identity_if_it_has_not_been_persisted
    assert_nil @subject.get(@subject.new(@factory.params).identity)
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end
end
