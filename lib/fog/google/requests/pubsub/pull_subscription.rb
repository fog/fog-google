module Fog
  module Google
    class Pubsub
      class Real
        # Pulls from a subscription. If option 'return_immediately' is
        # false, then this method blocks until one or more messages is
        # available or the remote server closes the connection.
        #
        # @param subscription [Subscription, #to_s] subscription instance or
        #   name of subscription to pull from
        # @param options [Hash] options to modify the pull request
        # @option options [Boolean] :return_immediately if true, method returns
        #   after API call; otherwise the connection is held open until
        #   messages are available or the remote server closes the connection
        #   (defaults to true)
        # @option options [Number] :max_messages maximum number of messages to
        #   retrieve (defaults to 10)
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.subscriptions/pull
        def pull_subscription(subscription, options = { :return_immediately => true, :max_messages => 10 })
          api_method = @pubsub.projects.subscriptions.pull

          parameters = {
            "subscription" => Fog::Google::Pubsub.subscription_name(subscription)
          }

          body = {
            "returnImmediately" => options[:return_immediately],
            "maxMessages" => options[:max_messages]
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def pull_subscription(subscription, options = { :return_immediately => true, :max_messages => 10 })
          # We're going to ignore return_immediately; feel free to add support
          # if you need it for testing
          subscription_name = Fog::Google::Pubsub.subscription_name(subscription)
          sub = data[:subscriptions][subscription_name]

          if sub.nil?
            subscription_resource = subscription_name.split("/")[-1]
            body = {
              "error" => {
                "code"    => 404,
                "message" => "Resource not found (resource=#{subscription_resource}).",
                "status"  => "NOT_FOUND"
              }
            }
            return build_excon_response(body, 404)
          end

          # This implementation is a bit weak; instead of "hiding" messages for
          # some period of time after they are pulled, instead we always return
          # them until acknowledged. This might cause issues with clients that
          # refuse to acknowledge.
          #
          # Also, note that here we use the message id as the ack id - again,
          # this might cause problems with some strange-behaving clients.
          msgs = sub[:messages].take(options[:max_messages]).map do |msg|
            {
              "ackId"   => msg["messageId"],
              "message" => msg
            }
          end

          body = {
            "receivedMessages" => msgs
          }
          status = 200
          build_excon_response(body, status)
        end
      end
    end
  end
end
