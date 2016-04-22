Shindo.tests("Fog::Google[:pubsub] | topic model", ["google"]) do
  @connection = Fog::Google[:pubsub]
  @topics = @connection.topics

  tests("success") do
    tests('#create').succeeds do
      @topic = @topics.create(:name => "projects/#{@connection.project}/topics/#{Fog::Mock.random_letters(16)}")
    end

    tests('#publish').succeeds do
      @topic.publish(["foo"])
    end

    tests('#destroy').succeeds do
      @topic.destroy
    end
  end
end
