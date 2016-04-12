module Fog
  module Google
    class Pubsub
      class Real
        # Retrieves a resource describing a topic.
        #
        # @param topic_name [#to_s] name of topic to retrieve
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/get
        def get_topic(topic_name)
          api_method = @pubsub.projects.topics.get
          parameters = {
            "topic" => topic_name.to_s
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_topic(topic_name)
          if !data[:topics].key?(topic_name)
            topic_resource = topic_name.split("/")[-1]
            body = {
              "error" => {
                "code"    => 404,
                "message" => "Resource not found (resource=#{topic_resource}).",
                "status"  => "NOT_FOUND"
              }
            }
            status = 404
          else
            body = data[:topics][topic_name].clone
            status = 200
          end

          build_excon_response(body, status)
        end
      end
    end
  end
end
