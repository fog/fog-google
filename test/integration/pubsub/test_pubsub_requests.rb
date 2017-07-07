require "helpers/integration_test_helper"
require "securerandom"
require "base64"

class TestPubsubRequests < FogIntegrationTest
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
        topics_result.topics.
          map(&:name).
          select { |t| t.start_with?(topic_resource_prefix) }.
          each { |t| @client.delete_topic(t) }
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
        subscriptions_result.subscriptions.
          map(&:name).
          select { |s| s.start_with?(subscription_resource_prefix) }.
          each { |s| @client.delete_subscription(s) }
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

  def test_create_topic
    name = new_topic_name
    result = @client.create_topic(name)
    assert_equal(result.name, name)
  end

  def test_get_topic
    result = @client.get_topic(some_topic_name)
    assert_equal(result.name, some_topic_name)
  end

  def test_list_topics
    # Force a topic to be created just so we have at least 1 to list
    name = new_topic_name
    @client.create_topic(name)

    Fog.wait_for(5) do
      result = @client.list_topics
      if result.topics.nil?
        false
      end

      result.topics.any? { |topic| topic.name == name }
    end
  end

  def test_delete_topic
    topic_to_delete = new_topic_name
    @client.create_topic(topic_to_delete)

    @client.delete_topic(topic_to_delete)
  end

  def test_publish_topic
    @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])
  end

  def test_create_subscription
    push_config = {}
    ack_deadline_seconds = 18

    subscription_name = new_subscription_name
    result = @client.create_subscription(subscription_name, some_topic_name,
                                         push_config, ack_deadline_seconds)
    assert_equal(result.name, subscription_name)
  end

  def test_get_subscription
    subscription_name = some_subscription_name
    result = @client.get_subscription(subscription_name)

    assert_equal(result.name, subscription_name)
  end

  def test_list_subscriptions
    # Force a subscription to be created just so we have at least 1 to list
    subscription_name = new_subscription_name
    @client.create_subscription(subscription_name, some_topic_name)

    Fog.wait_for(5) do
      result = @client.list_subscriptions
      if result.subscriptions.nil?
        false
      end

      result.subscriptions.any? { |sub| sub.name == subscription_name }
    end
  end

  def test_delete_subscription
    subscription_to_delete = new_subscription_name
    @client.create_subscription(subscription_to_delete, some_topic_name)

    @client.delete_subscription(subscription_to_delete)
  end

  def test_pull_subscription
    subscription_name = new_subscription_name
    message_bytes = Base64.strict_encode64("some message")
    @client.create_subscription(subscription_name, some_topic_name)
    @client.publish_topic(some_topic_name, [:data => message_bytes])

    result = @client.pull_subscription(subscription_name)

    contained = result.received_messages.any? { |received| received.message.data == message_bytes }
    assert_equal(true, contained, "sent messsage not contained within pulled responses")
  end

  def test_acknowledge_subscription
    subscription_name = new_subscription_name
    @client.create_subscription(subscription_name, some_topic_name)
    @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])
    pull_result = @client.pull_subscription(subscription_name)
    assert_operator(pull_result.received_messages.length, :>, 0)

    @client.acknowledge_subscription(subscription_name,
                                     pull_result.received_messages[0].ack_id)
  end
end
