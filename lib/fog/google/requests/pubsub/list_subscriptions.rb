module Fog
  module Google
    class Pubsub
      class Real
        # Gets a list of all subscriptions for a given project.
        #
        # @param_name project [#to_s] Project path to list subscriptions under;
        #   must be a project url prefix (e.g. 'projects/my-project'). If nil,
        #   the project configured on the client is used.
        # @see https://cloud.google.com/pubsub/reference/rest/v1/projects.topics/list
        def list_subscriptions(project = nil)
          api_method = @pubsub.projects.subscriptions.list
          parameters = {
            "project" => (project.nil? ? "projects/#{@project}" : project.to_s)
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_subscriptions(_project = nil)
          subs = data[:subscriptions].values.map do |sub|
            # Filter out any keys that aren't part of the response object
            sub.select do |k, _|
              %w(name topic pushConfig ackDeadlineSeconds).include?(k)
            end
          end

          body = {
            "subscriptions" => subs
          }
          status = 200
          build_excon_response(body, status)
        end
      end
    end
  end
end
