require "helpers/test_helper"

class UnitTestStorageXMLCollections < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google",
                               google_storage_access_key_id: "",
                               google_storage_secret_access_key: "")
    @bucket = @client.directories.create(key: "testbucket-#{SecureRandom.hex}")

    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class)

    @collections = descendants.select do |d|
      d.name.match(/Fog::Storage::GoogleXML/)
    end
  end

  def teardown
    Fog.unmock!
  end

  def test_common_methods
    # This tests whether Fog::Compute::Google collections have common lifecycle methods
    @collections.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:all), "#{klass} should have an .all method"
      assert obj.respond_to?(:get), "#{klass} should have a .get method"
      assert obj.respond_to?(:each), "#{klass} should behave like Enumerable"
    end
  end

  def test_collection_get_arguments
    @collections.each do |klass|
      obj = klass.new
      assert_operator(obj.method(:get).arity, :<=, 1,
                      "#{klass} should have at most 1 required parameter in get()")
    end
  end

  def test_metadata
    attr = { key: 'test-file', body: "hello world\x00" }
    f = @bucket.files.new(attr)
    assert_equal({}, f.metadata)

    metadata = { 'x-goog-meta-my-header' => 'hello world' }
    f = @bucket.files.new(attr.merge(metadata))
    assert_equal(metadata, f.metadata)
  end
end
