module Fog
  module Google
    class Pubsub
      class Real
        # Create a subscription resource on a topic.
        #
        # @param subscription_name [#to_s] name of the subscription to create.
        #   Note that it must follow the restrictions of subscription names;
        #   specifically it must be named within a project (e.g.
        #   "projects/my-project/subscriptions/my-subscripton")
        # @param topic [Topic, #to_s] topic instance or name of topic to create
        #   subscription on
        # @param push_config [Hash] configuration for a push config (if empty
        #   hash, then no push_config is created)
        # @param ack_deadline_seconds [Number] how long the service waits for
        #   an acknowledgement before redelivering the message; if nil then
        #   service default of 10 is used
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.subscriptions/create
        def create_subscription(subscription_name, topic, push_config = {}, ack_deadline_seconds = nil)
          api_method = @pubsub.projects.subscriptions.create

          parameters = {}
          parameters["name"] = subscription_name.to_s unless subscription_name.nil?

          body = {
            "topic" => (topic.is_a?(Topic) ? topic.name : topic.to_s)
          }

          if !push_config.nil? && push_config.key?("push_endpoint")
            body["pushConfig"] = push_config["push_endpoint"].clone
            body["pushConfig"]["attributes"] = push_config["attributes"] if push_config.key?("attributes")
          end

          body["ackDeadlineSeconds"] = ack_deadline_seconds unless ack_deadline_seconds.nil?

          request(api_method, parameters, body)
        end
      end

      class Mock
        def create_subscription(subscription_name, topic, push_config = {}, ack_deadline_seconds = nil)
          subscription = {
            "name"               => subscription_name,
            "topic"              => topic,
            "pushConfig"         => push_config,
            "ackDeadlineSeconds" => ack_deadline_seconds
          }

          # We also track pending messages
          data[:subscriptions][subscription_name] = subscription.merge(:messages => [])

          build_excon_response(subscription, 200)
        end
      end
    end
  end
end
