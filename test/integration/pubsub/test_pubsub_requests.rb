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
    topics = @client.list_topics[:body]["topics"]
    unless topics.nil?
      topics.
        map { |t| t["name"] }.
        select { |t| t.start_with?(topic_resource_prefix) }.
        each { |t| @client.delete_topic(t) }
    end

    subscriptions = @client.list_subscriptions[:body]["subscriptions"]
    unless subscriptions.nil?
      subscriptions.
        map { |s| s["name"] }.
        select { |s| s.start_with?(subscription_resource_prefix) }.
        each { |s| @client.delete_subscription(s) }
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
    @some_topic
  end

  def some_subscription_name
    # create lazily to speed tests up
    @some_subscription ||= new_subscription_name.tap do |s|
      @client.create_subscription(s, some_topic_name)
    end
    @some_subscription
  end

  def test_create_topic
    result = @client.create_topic(new_topic_name)

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "name", "resulting body should contain expected keys")
  end

  def test_get_topic
    result = @client.get_topic(some_topic_name)

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "name", "resulting body should contain expected keys")
  end

  def test_list_topics
    # Force a topic to be created just so we have at least 1 to list
    @client.create_topic(new_topic_name)
    result = @client.list_topics

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "topics", "resulting body should contain expected keys")
    assert_operator(result[:body]["topics"].size, :>, 0, "topic count should be positive")
  end

  def test_delete_topic
    topic_to_delete = new_topic_name
    @client.create_topic(topic_to_delete)

    result = @client.delete_topic(topic_to_delete)
    assert_equal(200, result.status, "request should be successful")
  end

  def test_publish_topic
    result = @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "messageIds", "resulting body should contain expected keys")
  end

  def test_create_subscription
    push_config = {}
    ack_deadline_seconds = 18

    result = @client.create_subscription(new_subscription_name, some_topic_name, push_config, ack_deadline_seconds)

    assert_equal(200, result.status, "request should be successful")
    assert((%w{name topic pushConfig ackDeadlineSeconds} - result[:body].keys).empty?,
           "resulting body should contain expected keys")
    assert_equal(18, result[:body]["ackDeadlineSeconds"], "ackDeadlineSeconds should be 18")
  end

  def test_get_subscription
    result = @client.get_subscription(some_subscription_name)

    assert_equal(200, result.status, "request should be successful")
    assert(%w{name topic pushConfig ackDeadlineSeconds} - result[:body].keys,
           "resulting body should contain expected keys")
  end

  def test_list_subscriptions
    # Force a subscription to be created just so we have at least 1 to list
    @client.create_subscription(new_subscription_name, some_topic_name)
    result = @client.list_subscriptions

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "subscriptions", "resulting body should contain expected keys")
    assert_operator(result[:body]["subscriptions"].size, :>, 0, "subscription count should be positive")
  end

  def test_delete_subscription
    subscription_to_delete = new_subscription_name
    @client.create_subscription(subscription_to_delete, some_topic_name)

    result = @client.delete_subscription(subscription_to_delete)
    assert_equal(200, result.status, "request should be successful")
  end

  def test_pull_subscription
    subscription = new_subscription_name
    @client.create_subscription(subscription, some_topic_name)
    @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])

    result = @client.pull_subscription(subscription)

    assert_equal(200, result.status, "request should be successful")
    assert_includes(result[:body].keys, "receivedMessages", "resulting body should contain expected keys")
    assert_equal(1, result[:body]["receivedMessages"].size, "we should have received a message")
    assert_equal("some message",
                 Base64.strict_decode64(result[:body]["receivedMessages"][0]["message"]["data"]),
                 "received message should be the same as what we sent")
  end

  def test_acknowledge_subscription
    subscription = new_subscription_name
    @client.create_subscription(subscription, some_topic_name)
    @client.publish_topic(some_topic_name, [:data => Base64.strict_encode64("some message")])
    pull_result = @client.pull_subscription(subscription)

    result = @client.acknowledge_subscription(subscription, pull_result[:body]["receivedMessages"][0]["ackId"])

    assert_equal(200, result.status, "request should be successful")
  end
end
