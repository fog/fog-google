module Fog
  module Google
    class Pubsub
      class Real
        # Publish a list of messages to a topic.
        #
        # @param messages [Array<Hash>] List of messages to be published to a
        #   topic; each hash should have a value defined for 'data' or for
        #   'attributes' (or both). Note that the value associated with 'data'
        #   must be base64 encoded.
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/publish
        def publish_topic(topic, messages)
          api_method = @pubsub.projects.topics.publish

          parameters = {
            "topic" => topic
          }

          body = {
            "messages" => messages
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def publish_topic(topic, messages)
          if data[:topics].key?(topic)
            published_messages = messages.map do |msg|
              msg.merge("messageId" => Fog::Mock.random_letters(16), "publishTime" => Time.now.iso8601)
            end

            # Gather the subscriptions and publish
            data[:subscriptions].values.each do |sub|
              next unless sub["topic"] == topic
              sub[:messages] += published_messages
            end

            body = {
              "messageIds" => published_messages.map { |msg| msg["messageId"] }
            }
            status = 200
          else
            topic_resource = topic_name.split("/")[-1]
            body = {
              "error" => {
                "code"    => 404,
                "message" => "Resource not found (resource=#{topic_resource}).",
                "status"  => "NOT_FOUND"
              }
            }
            status = 404
          end

          build_excon_response(body, status)
        end
      end
    end
  end
end
