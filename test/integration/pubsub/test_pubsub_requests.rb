require "helpers/integration_test_helper"
require "integration/pubsub/pubsub_shared"
require "securerandom"
require "base64"

class TestPubsubRequests < PubSubShared
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

    result = @client.pull_subscription(subscription_name, {:return_immediately => false})

    contained = result.received_messages.any? { |received| received.message.data == message_bytes }
    assert_equal(true, contained, "sent messsage not contained within pulled responses")
  end

  def test_acknowledge_subscription
    subscription_name = new_subscription_name
    @client.create_subscription(subscription_name, some_topic_name)
    @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])
    pull_result = @client.pull_subscription(subscription_name, {:return_immediately => false})
    assert_operator(pull_result.received_messages.length, :>, 0)

    @client.acknowledge_subscription(subscription_name,
                                     pull_result.received_messages[0].ack_id)
  end
end
