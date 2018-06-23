require "helpers/test_helper"

class UnitTestXMLRequests < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Storage.new(provider: "google",
                               google_storage_access_key_id: "",
                               google_storage_secret_access_key: "")
  end

  def teardown
    Fog.unmock!
  end

  def test_put_url_path_is_properly_escaped
    url = @client.put_object_url("bucket",
                                 "just some file.json",
                                 Time.now + 2 * 60,
                                 "Content-Type" => "application/json")

    assert_match(/just%20some%20file\.json/, url,
                 "space should be escaped with '%20'")
  end
end
