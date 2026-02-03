require "helpers/test_helper"

class UnitTestXMLRequests < Minitest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google",
                               google_storage_access_key_id: "",
                               google_storage_secret_access_key: "")
  end

  def teardown
    Fog.unmock!
  end

  def test_get_http_url
    url = @client.get_object_http_url("bucket",
                                      "just some file.json",
                                      Time.now + 2 * 60)
    assert_match(/^http:\/\//, url,
                 "URL starts with HTTP")
  end

  def test_get_https_url
    url = @client.get_object_https_url("bucket",
                                       "just some file.json",
                                       Time.now + 2 * 60)
    assert_match(/^https:\/\//, url,
                 "URL starts with HTTPS")
  end

  def test_get_url_path_has_query_params
    url = @client.get_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 query: { "Response-Content-Disposition" => 'inline; filename="test.json"' })

    assert_match(/Response-Content-Disposition=inline%3B%20filename%3D%22test.json/, url,
                 "query string should be escaped")
  end

  def test_get_url_filter_nil_query_params
    url = @client.get_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 query: { "Response-Content-Disposition" => nil })

    refute_match(/Response-Content-Disposition/, url,
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

  def test_get_object_https_url_uses_default_host
    url = @client.get_object_https_url("my-bucket",
                                       "my-file.txt",
                                       Time.now + 2 * 60)

    assert_match(%r{^https://storage\.googleapis\.com/}, url,
                 "URL should use default storage.googleapis.com host")
  end

  def test_host_attribute_defaults_to_storage_googleapis_com
    assert_equal Fog::Google::StorageXML::GOOGLE_STORAGE_HOST, @client.host,
                 "host attribute should default to GOOGLE_STORAGE_HOST"
  end

  def test_universe_domain_support
    Fog.unmock!
    Fog.mock!

    client = Fog::Storage.new(
      provider: "google",
      google_storage_access_key_id: "",
      google_storage_secret_access_key: "",
      universe_domain: "example.com"
    )

    assert_equal "storage.example.com", client.host,
                 "host should be derived from universe_domain"
  ensure
    Fog.unmock!
    Fog.mock!
  end

  def test_get_object_https_url_with_universe_domain
    Fog.unmock!
    Fog.mock!

    client = Fog::Storage.new(
      provider: "google",
      google_storage_access_key_id: "",
      google_storage_secret_access_key: "",
      universe_domain: "custom-universe.com"
    )

    url = client.get_object_https_url("my-bucket",
                                      "my-file.txt",
                                      Time.now + 2 * 60)

    assert_match(%r{^https://storage\.custom-universe\.com/}, url,
                 "URL should use universe domain host")
  ensure
    Fog.unmock!
    Fog.mock!
  end
end
