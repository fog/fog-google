require "helpers/test_helper"
require "google/apis/storage_v1"

class TestStorageJSONUniverseDomain < Minitest::Test
  # Simple stub class to avoid minitest-mock bug in Ruby 3.1
  class StorageServiceStub
    attr_reader :universe_domain_called_with

    def initialize
      @universe_domain_called_with = []
    end

    def universe_domain=(value)
      @universe_domain_called_with << value
    end
  end

  def setup
    Fog.mock!
    # Clear any existing env variable
    @original_env = ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"]
    ENV.delete("GOOGLE_CLOUD_UNIVERSE_DOMAIN")
  end

  def teardown
    Fog.unmock!
    # Restore original env variable
    if @original_env
      ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"] = @original_env
    else
      ENV.delete("GOOGLE_CLOUD_UNIVERSE_DOMAIN")
    end
  end

  def test_default_universe_domain
    client = Fog::Storage.new(provider: "google", google_project: "test-project")

    assert_equal "https://storage.googleapis.com/", client.bucket_base_url
    assert_equal Fog::Google::StorageJSON::GOOGLE_STORAGE_HOST, client.host
  end

  def test_custom_universe_domain_via_option
    client = Fog::Storage.new(
      provider: "google",
      google_project: "test-project",
      universe_domain: "example.com"
    )

    assert_equal "https://storage.example.com/", client.bucket_base_url
    assert_equal "storage.example.com", client.host
  end

  def test_custom_universe_domain_via_env_variable
    ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"] = "test-universe.com"

    client = Fog::Storage.new(provider: "google", google_project: "test-project")

    assert_equal "https://storage.test-universe.com/", client.bucket_base_url
    assert_equal "storage.test-universe.com", client.host
  end

  def test_option_takes_precedence_over_env_variable
    ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"] = "env-universe.com"

    client = Fog::Storage.new(
      provider: "google",
      google_project: "test-project",
      universe_domain: "option-universe.com"
    )

    assert_equal "https://storage.option-universe.com/", client.bucket_base_url
    assert_equal "storage.option-universe.com", client.host
  end

  def test_universe_domain_with_real_client
    Fog.unmock!

    json_key_text = {
      client_id: "test-client-id.apps.googleusercontent.com",
      client_secret: "notsosecret",
      refresh_token: "refreshing-token",
      type: "authorized_user",
      universe_domain: "custom.universe.com"
    }.to_json
    mock_credentials = Google::Auth::UserRefreshCredentials.make_creds(
      json_key_io: StringIO.new(json_key_text)
    )
    mock_storage_service = StorageServiceStub.new

    ::Google::Auth.stub(:get_application_default, mock_credentials) do
      ::Google::Apis::StorageV1::StorageService.stub(:new, mock_storage_service) do
        client = Fog::Google::StorageJSON::Real.new(
          google_project: "test-project",
          universe_domain: "custom.universe.com",
          google_application_default: true
        )

        assert_equal "https://storage.custom.universe.com/", client.bucket_base_url
        assert_equal ["custom.universe.com"], mock_storage_service.universe_domain_called_with
      end
    end
  ensure
    Fog.mock!
  end

  def test_universe_domain_not_set_on_service_when_nil
    Fog.unmock!

    json_key_text = {
      client_id: "test-client-id.apps.googleusercontent.com",
      client_secret: "notsosecret",
      refresh_token: "refreshing-token",
      type: "authorized_user"
    }.to_json
    mock_credentials = Google::Auth::UserRefreshCredentials.make_creds(
      json_key_io: StringIO.new(json_key_text)
    )
    mock_storage_service = StorageServiceStub.new

    ::Google::Auth.stub(:get_application_default, mock_credentials) do
      ::Google::Apis::StorageV1::StorageService.stub(:new, mock_storage_service) do
        client = Fog::Google::StorageJSON::Real.new(
          google_project: "test-project",
          google_application_default: true
        )

        assert_equal "https://storage.googleapis.com/", client.bucket_base_url
        # Verify universe_domain= was NOT called
        assert_empty mock_storage_service.universe_domain_called_with
      end
    end
  ensure
    Fog.mock!
  end

  def test_universe_domain_set_on_application_default_credentials
    Fog.unmock!

    json_key_text = {
      client_id: "test-client-id.apps.googleusercontent.com",
      client_secret: "notsosecret",
      refresh_token: "refreshing-token",
      type: "authorized_user",
      universe_domain: "custom.universe.com"
    }.to_json
    mock_credentials = Google::Auth::UserRefreshCredentials.make_creds(
      json_key_io: StringIO.new(json_key_text)
    )
    mock_storage_service = StorageServiceStub.new

    ::Google::Auth.stub(:get_application_default, mock_credentials) do
      ::Google::Apis::StorageV1::StorageService.stub(:new, mock_storage_service) do
        Fog::Google::StorageJSON::Real.new(
          google_project: "test-project",
          universe_domain: "custom.universe.com",
          google_application_default: true
        )
      end
    end

    assert_equal ["custom.universe.com"], mock_storage_service.universe_domain_called_with
  ensure
    Fog.mock!
  end

  def test_universe_domain_set_on_json_key_credentials
    Fog.unmock!

    json_key = {
      client_secret: "privatekey",
      client_id: "client123",
      refresh_token: "refreshtoken",
      type: "authorized_user",
      quota_project_id: "test_project",
      private_key: OpenSSL::PKey::RSA.new(2048),
      universe_domain: "custom.universe.com"
    }.to_json
    mock_credentials = Google::Auth::UserRefreshCredentials.make_creds(
      json_key_io: StringIO.new(json_key),
      scope: "https://www.googleapis.com/auth/userinfo.profile"
    )
    mock_storage_service = StorageServiceStub.new

    ::Google::Auth::ServiceAccountCredentials.stub(:make_creds, mock_credentials) do
      ::Google::Apis::StorageV1::StorageService.stub(:new, mock_storage_service) do
        Fog::Google::StorageJSON::Real.new(
          google_project: "test-project",
          universe_domain: "custom.universe.com",
          google_json_key_string: json_key
        )
      end
    end

    assert_equal ["custom.universe.com"], mock_storage_service.universe_domain_called_with
  ensure
    Fog.mock!
  end
end
