require "helpers/test_helper"

class TestShared < Minitest::Test
  # Test class that includes Fog::Google::Shared
  class TestClient
    include Fog::Google::Shared
  end

  # Simple stub service class
  class ServiceStub
    attr_reader :universe_domain_called_with
    attr_accessor :client_options

    def initialize
      @universe_domain_called_with = []
      @client_options = Struct.new(:members, :test_option).new([:test_option], nil)
    end

    def universe_domain=(value)
      @universe_domain_called_with << value
    end
  end

  def setup
    @client = TestClient.new
    @service = ServiceStub.new
  end

  def test_apply_client_options_sets_universe_domain
    options = { universe_domain: "custom.universe.com" }
    
    @client.apply_client_options(@service, options)
    
    assert_equal ["custom.universe.com"], @service.universe_domain_called_with
  end

  def test_apply_client_options_does_not_set_universe_domain_when_nil
    options = {}
    
    @client.apply_client_options(@service, options)
    
    assert_empty @service.universe_domain_called_with
  end

  def test_apply_client_options_uses_env_variable
    ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"] = "env.universe.com"
    options = {}
    
    @client.apply_client_options(@service, options)
    
    assert_equal ["env.universe.com"], @service.universe_domain_called_with
  ensure
    ENV.delete("GOOGLE_CLOUD_UNIVERSE_DOMAIN")
  end

  def test_apply_client_options_prefers_option_over_env
    ENV["GOOGLE_CLOUD_UNIVERSE_DOMAIN"] = "env.universe.com"
    options = { universe_domain: "option.universe.com" }
    
    @client.apply_client_options(@service, options)
    
    assert_equal ["option.universe.com"], @service.universe_domain_called_with
  ensure
    ENV.delete("GOOGLE_CLOUD_UNIVERSE_DOMAIN")
  end

  def test_apply_client_options_sets_google_client_options
    options = {
      universe_domain: "custom.universe.com",
      google_client_options: { test_option: "test_value" }
    }
    
    @client.apply_client_options(@service, options)
    
    assert_equal ["custom.universe.com"], @service.universe_domain_called_with
    assert_equal "test_value", @service.client_options.test_option
  end

  def test_apply_client_options_works_without_google_client_options
    options = { universe_domain: "custom.universe.com" }
    
    @client.apply_client_options(@service, options)
    
    assert_equal ["custom.universe.com"], @service.universe_domain_called_with
  end
end
