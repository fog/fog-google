require "helpers/test_helper"

class UnitTestStorageXMLFiles < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google",
                               google_storage_access_key_id: "key",
                               google_storage_secret_access_key: "secret")
    directory = @client.directories.create(key: "bucket")
    # keys on both sides of the prefix, so that losing it would bring them in
    %w(0/1 a/1 a/2 a/3 b/1).each { |key| directory.files.create(key: key, body: "x") }
    @listings = []
  end

  def teardown
    @client.reset_data
    Fog.unmock!
  end

  def test_each_keeps_options_given_to_all
    keys = []
    record_get_bucket do
      files.all(prefix: "a/", max_keys: 2).each { |file| keys << file.key }
    end

    assert_equal(%w(a/1 a/2 a/3), keys)
    assert_equal(["a/", "a/", "a/"], @listings.map { |options| options["prefix"] },
                 "every page should be listed with the prefix")
  end

  private

  def files
    @client.directories.new(key: "bucket").files
  end

  def record_get_bucket(&block)
    get_bucket = @client.method(:get_bucket)
    spy = lambda do |bucket, options|
      @listings << options.dup
      get_bucket.call(bucket, options)
    end
    @client.stub(:get_bucket, spy, &block)
  end
end
