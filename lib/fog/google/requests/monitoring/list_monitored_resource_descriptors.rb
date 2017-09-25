module Fog
  module Google
    class Monitoring
      ##
      # Describes the schema of a MonitoredResource (a resource object that can be used for monitoring, logging,
      # billing, or other purposes) using a type name and a set of labels.
      #
      # @see https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.monitoredResourceDescriptors/list
      class Real
        def list_monitored_resource_descriptors(options = {})
          api_method = @monitoring.projects.monitored_resource_descriptors.list
          parameters = {
            "name" => "projects/#{@project}"
          }

          parameters["filter"] = options[:filter] if options.key?(:filter)
          parameters["pageSize"] = options[:page_size] if options.key?(:page_size)
          parameters["pageToken"] = options[:page_token] if options.key?(:page_token)

          request(api_method, parameters)
        end
      end

      class Mock
        def list_monitored_resource_descriptors(_options = {})
          body = {
            "resourceDescriptors" => [
              {
                "type" => "api",
                "displayName" => "Produced API",
                "description" => "An API provided by the producer.",
                "labels" => [
                  {
                    "key" => "project_id",
                    "description" => "The identifier of the GCP project associated with this resource (e.g., my-project)."
                  },
                  {
                    "key" => "service",
                    "description" => "API service name e.g. \"cloudsql.googleapis.com\"."
                  },
                  {
                    "key" => "method",
                    "description" => "API method e.g. \"disks.list\"."
                  },
                  {
                    "key" => "version",
                    "description" => "API version e.g. \"v1\"."
                  },
                  {
                    "key" => "location",
                    "description" => "The service specific notion of location. This can be a name of a zone, region, or \"global."
                  }
                ],
                "name" => "projects/#{@project}/monitoredResourceDescriptors/api"
              }
            ]
          }
          build_excon_response(body)
        end
      end
    end
  end
end
