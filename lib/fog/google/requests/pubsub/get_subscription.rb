module Fog
  module Google
    class Pubsub
      class Real
        # Retrieves a subscription by name from the remote service.
        #
        # @param subscription_name [#to_s] name of subscription to retrieve
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/get
        def get_subscription(subscription_name)
          api_method = @pubsub.projects.subscriptions.get
          parameters = {
            "subscription" => subscription_name.to_s
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_subscription(subscription_name)
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

          body = sub.select do |k, _|
            %w(name topic pushConfig ackDeadlineSeconds).include?(k)
          end
          status = 200

          build_excon_response(body, status)
        end
      end
    end
  end
end
