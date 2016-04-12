module Fog
  module Google
    class Pubsub
      class Real
        # Delete a topic on the remote service.
        #
        # @param topic_name [#to_s] name of topic to delete
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/delete
        def delete_topic(topic_name)
          api_method = @pubsub.projects.topics.delete
          parameters = {
            "topic" => topic_name.to_s
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_topic(topic_name)
          data[:topics].delete(topic_name)

          status = 200
          build_excon_response(nil, status)
        end
      end
    end
  end
end
