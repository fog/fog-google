module Fog
  module Google
    class Pubsub
      class Real
        # Acknowledges a message received from a subscription.
        #
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.subscriptions/acknowledge
        def acknowledge_subscription(subscription, ack_ids)
          api_method = @pubsub.projects.subscriptions.acknowledge

          parameters = {
            "subscription" => subscription.to_s
          }

          body = {
            "ackIds" => ack_ids
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def acknowledge_subscription(subscription, ack_ids)
          unless data[:subscriptions].key?(subscription)
            subscription_resource = subscription.to_s.split("/")[-1]
            body = {
              "error" => {
                "code"    => 404,
                "message" => "Resource not found (resource=#{subscription_resource}).",
                "status"  => "NOT_FOUND"
              }
            }
            status = 404
            return build_excon_response(body, status)
          end

          sub = data[:subscriptions][subscription]
          sub[:messages].delete_if { |msg| ack_ids.member?(msg["messageId"]) }

          build_excon_response(nil, 200)
        end
      end
    end
  end
end
