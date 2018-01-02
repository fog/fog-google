require "helpers/integration_test_helper"
require "securerandom"
require "base64"

class PubSubShared < FogIntegrationTest
  def setup
    @client = Fog::Google::Pubsub.new
    # Ensure any resources we create with test prefixes are removed
    Minitest.after_run do
      delete_test_resources
    end
  end

  def delete_test_resources
    topics_result = @client.list_topics
    unless topics_result.topics.nil?
      begin
        topics_result.topics
                     .map(&:name)
                     .select { |t| t.start_with?(topic_resource_prefix) }
                     .each { |t| @client.delete_topic(t) }
      # We ignore errors here as list operations may not represent changes applied recently.
      # Hence, list operations can return a topic which has already been deleted but which we
      # will attempt to delete again.
      rescue Google::Apis::Error
        Fog::Logger.warning("ignoring Google Api error during delete_test_resources")
      end
    end

    subscriptions_result = @client.list_subscriptions
    unless subscriptions_result.subscriptions.nil?
      begin
        subscriptions_result.subscriptions
                            .map(&:name)
                            .select { |s| s.start_with?(subscription_resource_prefix) }
                            .each { |s| @client.delete_subscription(s) }
      # We ignore errors here as list operations may not represent changes applied recently.
      # Hence, list operations can return a topic which has already been deleted but which we
      # will attempt to delete again.
      rescue Google::Apis::Error
        Fog::Logger.warning("ignoring Google Api error during delete_test_resources")
      end
    end
  end

  def topic_resource_prefix
    "projects/#{@client.project}/topics/fog-integration-test"
  end

  def subscription_resource_prefix
    "projects/#{@client.project}/subscriptions/fog-integration-test"
  end

  def new_topic_name
    "#{topic_resource_prefix}-#{SecureRandom.uuid}"
  end

  def new_subscription_name
    "#{subscription_resource_prefix}-#{SecureRandom.uuid}"
  end

  def some_topic_name
    # create lazily to speed tests up
    @some_topic ||= new_topic_name.tap do |t|
      @client.create_topic(t)
    end
  end

  def some_subscription_name
    # create lazily to speed tests up
    @some_subscription ||= new_subscription_name.tap do |s|
      @client.create_subscription(s, some_topic_name)
    end
  end
end
