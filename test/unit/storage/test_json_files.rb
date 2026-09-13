require "helpers/test_helper"
require "google/apis/storage_v1"

class UnitTestStorageJSONFiles < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google", google_project: "foo")
    @listings = []
  end

  def teardown
    Fog.unmock!
  end

  def test_each_keeps_options_given_to_all
    keys = []
    stub_list_objects(nil => [%w(a/1 a/2), "a/2"], "a/2" => [%w(a/3), nil]) do
      files.all(prefix: "a/").each { |file| keys << file.key }
    end

    assert_equal(%w(a/1 a/2 a/3), keys)
    assert_equal(["a/", "a/", "a/"], @listings.map { |options| options[:prefix] },
                 "every page should be listed with the prefix")
  end

  def test_all_takes_options_by_attribute_name_or_alias
    ["prefix", "Prefix", :prefix].each do |key|
      @listings.clear
      stub_list_objects(nil => [%w(a/1), nil]) do
        files.all(key => "a/")
      end

      assert_equal("a/", @listings.last[:prefix], "#{key.inspect} should be passed on as :prefix")
    end
  end

  private

  def files
    @client.directories.new(key: "bucket").files
  end

  # pages: { page_token => [names, next_page_token] }
  def stub_list_objects(pages, &block)
    list_objects = lambda do |_bucket, options|
      @listings << options
      names, next_page_token = pages.fetch(options[:page_token])
      ::Google::Apis::StorageV1::Objects.new(
        items: names.map { |name| ::Google::Apis::StorageV1::Object.new(name: name) },
        next_page_token: next_page_token
      )
    end
    @client.stub(:list_objects, list_objects, &block)
  end
end
