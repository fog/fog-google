require "helpers/integration_test_helper"
require "integration/pubsub/pubsub_shared"
require "securerandom"
require "base64"

class TestPubsubModels < PubSubShared
  def test_topics_create
    name = new_topic_name
    result = @client.topics.create(:name => name)
    assert_equal(result.name, name)
  end

  def test_topics_get
    result = @client.topics.get(some_topic_name)
    assert_equal(result.name, some_topic_name)
  end

  def test_topics_all
    # Force a topic to be created just so we have at least 1 to list
    name = new_topic_name
    @client.create_topic(name)

    Fog.wait_for(5) do
      result = @client.topics.all
      if result.nil?
        false
      end

      result.any? { |topic| topic.name == name }
    end
  end

  def test_topic_publish_string
    @client.topics.get(some_topic_name)
    message_ids = @client.topics.get(some_topic_name).publish(["apples"])
    assert_operator(message_ids.length, :>, 0)
  end

  def test_topic_publish_hash
    @client.topics.get(some_topic_name)
    message_ids = @client.topics.get(some_topic_name).publish(["data" => "apples"])
    assert_operator(message_ids.length, :>, 0)
  end

  def test_topic_delete
    topic_to_delete = new_topic_name
    topic = @client.topics.create(:name => topic_to_delete)

    topic.destroy
  end

  def test_subscriptions_create
    push_config = {}
    ack_deadline_seconds = 18

    subscription_name = new_subscription_name
    result = @client.subscriptions.create(:name => subscription_name,
                                          :topic => some_topic_name,
                                          :push_config => push_config,
                                          :ack_deadline_seconds => ack_deadline_seconds)
    assert_equal(result.name, subscription_name)
  end

  def test_subscriptions_get
    subscription_name = some_subscription_name
    result = @client.subscriptions.get(subscription_name)

    assert_equal(result.name, subscription_name)
  end

  def test_subscriptions_list
    # Force a subscription to be created just so we have at least 1 to list
    subscription_name = new_subscription_name
    @client.subscriptions.create(:name => subscription_name, :topic => some_topic_name)

    Fog.wait_for(5) do
      result = @client.subscriptions.all
      if result.nil?
        false
      end

      result.any? { |subscription| subscription.name == subscription_name }
    end
  end

  def test_subscription_delete
    push_config = {}
    ack_deadline_seconds = 18

    subscription_name = new_subscription_name
    subscription = @client.subscriptions.create(:name => subscription_name,
                                                :topic => some_topic_name,
                                                :push_config => push_config,
                                                :ack_deadline_seconds => ack_deadline_seconds)
    subscription.destroy
  end

  def test_subscription_pull
    subscription_name = new_subscription_name
    message_bytes = Base64.strict_encode64("some message")
    subscription = @client.subscriptions.create(:name => subscription_name,
                                                :topic => some_topic_name)
    @client.topics.get(some_topic_name).publish(["data" => message_bytes])

    result = subscription.pull(:return_immediately => false)
    assert_operator(result.length, :>, 0)

    contained = result.any? { |received| received.message[:data] == message_bytes }
    assert_equal(true, contained, "sent messsage not contained within pulled responses")
  end

  def test_subscription_acknowledge
    subscription_name = new_subscription_name
    subscription = @client.subscriptions.create(:name => subscription_name,
                                                :topic => some_topic_name)
    @client.topics.get(some_topic_name).publish(["data" => Base64.strict_encode64("some message")])

    result = subscription.pull(:return_immediately => false)
    assert_operator(result.length, :>, 0)

    subscription.acknowledge([result[0].ack_id])
  end

  def test_message_acknowledge
    subscription_name = new_subscription_name
    subscription = @client.subscriptions.create(:name => subscription_name,
                                                :topic => some_topic_name)
    @client.topics.get(some_topic_name).publish(["data" => Base64.strict_encode64("some message")])

    result = subscription.pull(:return_immediately => false)
    assert_operator(result.length, :>, 0)

    result[0].acknowledge
  end
end
