require "helpers/test_helper"

class UnitTestJsonRequests < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google",
                               google_project: "",
                               google_json_key_location: "")
  end

  def teardown
    Fog.unmock!
  end

  def test_get_url_path_has_query_params
    url = @client.get_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 query: { "projection" => 'full, noAcl"' })

    assert_match(/projection=full%2C%20noAcl/, url,
                 "query string should be escaped")
  end

  def test_get_url_filter_nil_query_params
    url = @client.get_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 query: { "projection" => nil })

    refute_match(/projection/, url,
                 "nil query params should be omitted")
  end

  def test_put_url_path_is_properly_escaped
    url = @client.put_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 "Content-Type" => "application/json")

    assert_match(/just%20some%20file\.json/, url,
                 "space should be escaped with '%20'")
  end

  def test_unescaped_slashes_in_url
    url = @client.get_object_https_url("bucket",
                                       "a/b/c.ext",
                                       Time.now + 2 * 60)
    assert_match(/a\/b\/c/, url,
                 "slashes should not be escaped with '%2F'")
  end

  def test_unescaped_pluses_in_url
    url = @client.get_object_https_url("bucket",
                                       "a+c.ext",
                                       Time.now + 2 * 60)
    assert_match(/a\+c/, url,
                 "pluses should not be escaped with '%2B'")
  end

  def test_get_object_https_url_uses_default_host
    url = @client.get_object_https_url("my-bucket",
                                       "my-file.txt",
                                       Time.now + 2 * 60)

    assert_match(%r{^https://storage\.googleapis\.com/}, url,
                 "URL should use default storage.googleapis.com host")
  end

  def test_get_object_https_url_with_custom_universe_domain
    Fog.unmock!
    Fog.mock!

    client = Fog::Storage.new(
      provider: "google",
      google_project: "test-project",
      universe_domain: "example.com"
    )

    url = client.get_object_https_url("my-bucket",
                                      "my-file.txt",
                                      Time.now + 2 * 60)

    assert_match(%r{^https://storage\.example\.com/}, url,
                 "URL should use custom universe domain host")
  ensure
    Fog.unmock!
    Fog.mock!
  end

  def test_host_attribute_set_correctly
    assert_equal Fog::Google::Storage::GOOGLE_STORAGE_HOST, @client.host,
                 "host attribute should be set to GOOGLE_STORAGE_HOST by default"
  end

  def test_host_attribute_with_custom_universe_domain
    Fog.unmock!
    Fog.mock!

    client = Fog::Storage.new(
      provider: "google",
      google_project: "test-project",
      universe_domain: "custom-universe.com"
    )

    assert_equal "storage.custom-universe.com", client.host,
                 "host attribute should match custom universe domain"
  ensure
    Fog.unmock!
    Fog.mock!
  end
end
