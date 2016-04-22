module Fog
  module Google
    class Pubsub
      class Real
        # Delete a subscription on the remote service.
        #
        # @param subscription_name [#to_s] name of subscription to delete
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.subscriptions/delete
        def delete_subscription(subscription_name)
          api_method = @pubsub.projects.subscriptions.delete
          parameters = {
            "subscription" => subscription_name.to_s
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def delete_subscription(subscription_name)
          data[:subscriptions].delete(subscription_name)

          build_excon_response(nil, 200)
        end
      end
    end
  end
end
