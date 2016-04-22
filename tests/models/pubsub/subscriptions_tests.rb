Shindo.tests("Fog::Google[:pubsub] | subscriptions model", ["google"]) do
  @connection = Fog::Google[:pubsub]
  @topic = @connection.topics.create(:name => "projects/#{@connection.project}/topics/#{Fog::Mock.random_letters(16)}")
  @subscriptions = @connection.subscriptions
  @subscription = @subscriptions.create(
    :name => "projects/#{@connection.project}/subscriptions/#{Fog::Mock.random_letters(16)}",
    :topic => @topic.name
  )

  tests("success") do
    tests('#all').succeeds do
      @subscriptions.all
    end

    tests('#get').succeeds do
      @subscriptions.get(@subscription.name)
    end
  end

  @subscription.destroy

  tests("failure") do
    tests('#all').returns([]) do
      @subscriptions.all
    end

    tests('#get').returns(nil) do
      @subscriptions.get(Fog::Mock.random_letters_and_numbers(16))
    end
  end

  @topic.destroy
end
