Shindo.tests("Fog::Google[:pubsub] | received_message model", ["google"]) do
  @connection = Fog::Google[:pubsub]
  @topic = @connection.topics.create(:name => "projects/#{@connection.project}/topics/#{Fog::Mock.random_letters(16)}")
  @subscription = @connection.subscriptions.create(
    :name  => "projects/#{@connection.project}/subscriptions/#{Fog::Mock.random_letters(16)}",
    :topic => @topic.name
  )

  tests("success") do
    tests('#acknowledge').returns(nil) do
      @topic.publish(["foo"])
      @subscription.pull[0].acknowledge
    end
  end
  # teardown
  @topic.destroy
  @subscription.destroy
end
