module TestCollection
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

    # Some factories that have scoped parameters (zone, region) have a special
    # `get` method defined in the factory to pass the correct parameters in
    if @factory.respond_to?(:get)
      assert_equal one.identity, @factory.get(one.identity).identity
      assert_equal two.identity, @factory.get(two.identity).identity
    end

    # Some factories that have scoped parameters (zone, region) have a special
    # `all` method defined in the factory to pass the correct parameters in
    if @factory.respond_to?(:all)
      subject_list = @subject.all
      scoped_subject_list = @factory.all

      # Assert that whatever .all(scope) returns is a subset of .all
      assert(scoped_subject_list.all? { |x| subject_list.include? x },
             "Output of @factory.all must be a subset of @subject.all")
    end

    one.destroy
    two.destroy

    Fog.wait_for { !@subject.all.map(&:identity).include? one.identity }
    Fog.wait_for { !@subject.all.map(&:identity).include? two.identity }
  end

  def test_get_returns_nil_if_resource_does_not_exist
    assert_nil @factory.get("fog-test-fake-identity") if @factory.respond_to?(:get)
    assert_nil @subject.get("fog-test-fake-identity")
  end

  def test_enumerable
    assert_respond_to @subject, :each
  end

  def test_nil_get
    assert_nil @subject.get(nil)
  end

  def teardown
    @factory.cleanup
  end
end
