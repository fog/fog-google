module Fog
  module Google
    class Pubsub
      class Real
        # Create a topic on the remote service.
        #
        # @param topic_name [#to_s] name of topic to create; note that it must
        #   obey the naming rules for a topic (e.g.
        #   'projects/myProject/topics/my_topic')
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/create
        def create_topic(topic_name)
          api_method = @pubsub.projects.topics.create
          parameters = {
            "name" => topic_name.to_s
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def create_topic(topic_name)
          data = {
            "name" => topic_name
          }
          self.data[:topics][topic_name] = data

          body = data.clone
          status = 200

          build_excon_response(body, status)
        end
      end
    end
  end
end
