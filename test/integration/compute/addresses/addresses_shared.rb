require "helpers/integration_test_helper"
require "helpers/client_helper"
require "securerandom"

class TestComputeAddressShared < FogIntegrationTest
  DEFAULT_REGION = "us-central1".freeze
  ADDRESS_RESOURCE_PREFIX = "fog-test-address".freeze

  include ClientHelper

  def delete_test_resources
    client = Fog::Compute::Google.new
    addresses = client.list_addresses(DEFAULT_REGION).items
    unless addresses.nil?
      addresses
        .map(&:name)
        .select { |a| a.start_with?(ADDRESS_RESOURCE_PREFIX) }
        .each { |a| client.delete_address(a, DEFAULT_REGION) }
    end
  end

  attr_reader :client

  def setup
    @client = Fog::Compute::Google.new
  end

  def teardown
    delete_test_resources
  end

  def new_address_name
    "#{ADDRESS_RESOURCE_PREFIX}-#{SecureRandom.uuid}"
  end

  def some_address_name
    # created lazily to speed tests up
    @some_address ||= new_address_name.tap do |a|
      result = @client.insert_address(a, DEFAULT_REGION)
      Fog.wait_for { operation_finished?(result) }
    end
  end
end
