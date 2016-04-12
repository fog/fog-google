Shindo.tests("Fog::Google[:pubsub] | topics model", ["google"]) do
  @connection = Fog::Google[:pubsub]
  @topics = @connection.topics
  @topic = @topics.create(:name => "projects/#{@connection.project}/topics/#{Fog::Mock.random_letters(16)}")

  tests("success") do
    tests('#all').succeeds do
      @topics.all
    end

    tests('#get').succeeds do
      @topics.get(@topic.name)
    end
  end

  @topic.destroy

  tests("failure") do
    tests('#all').returns([]) do
      @topics.all
    end

    tests('#get').returns(nil) do
      @topics.get(Fog::Mock.random_letters_and_numbers(16))
    end
  end
end
