Shindo.tests("Fog::Google[:pubsub] | subscription model", ["google"]) do
  @connection = Fog::Google[:pubsub]
  @topic = @connection.topics.create(:name => "projects/#{@connection.project}/topics/#{Fog::Mock.random_letters(16)}")
  @subscriptions = @connection.subscriptions

  tests("success") do
    tests('#create').succeeds do
      @subscription = @subscriptions.create(
        :name  => "projects/#{@connection.project}/subscriptions/#{Fog::Mock.random_letters(16)}",
        :topic => @topic.name
      )
    end

    tests('#pull').returns("foo") do
      @topic.publish(["foo"])
      @message = @subscription.pull[0]
      @message.message["data"]
    end

    tests('#destroy').succeeds do
      @subscription.destroy
    end
  end

  @topic.destroy
end
