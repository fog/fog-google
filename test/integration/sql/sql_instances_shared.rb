require "helpers/integration_test_helper"
require "helpers/client_helper"

class TestSqlInstancesShared < FogIntegrationTest
  include ClientHelper
  attr_reader :client

  INSTANCE_NAME = "fogtest-#{Fog::Mock.random_letters(8)}".freeze

  def setup
    @client = Fog::Google::SQL.new
    Minitest.after_run do
      delete_test_resources
    end
  end

  def delete_test_resources
    try_delete_instance(INSTANCE_NAME)
  end

  def some_instance_name
    # Create one test instance per generation per test suite.
    INSTANCE_NAME.tap do |name|
      begin
        @client.get_instance(name)
      rescue ::Google::Apis::ClientError
        create_test_instance(INSTANCE_NAME,
                             TEST_SQL_TIER_FIRST,
                             TEST_SQL_REGION_FIRST)
      end
    end
  end

  def some_clone_name
    "#{INSTANCE_NAME}-clone"
  end

  def create_test_instance(instance_name, tier, region)
    # Create one test instance per generation per test suite.
    Fog::Logger.debug("creating test SQL instance...")
    # Create test instance if it hasn't been created yet
    @client = Fog::Google::SQL.new
    wait_until_complete do
      @client.insert_instance(instance_name, tier, :region => region)
    end
  end

  def try_delete_instance(instance)
    @client = Fog::Google::SQL.new
    wait_until_complete { @client.delete_instance(instance) }
  rescue ::Google::Apis::ClientError => e
    # 409: Invalid state
    # 404: Not found
    raise e unless e.status_code == 404 || e.status_code == 409
    Fog::Logger.warning("ignoring error in try_delete_instance")
  end
end
