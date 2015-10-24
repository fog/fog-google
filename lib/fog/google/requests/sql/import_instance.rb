module Fog
  module Google
    class SQL
      ##
      # Imports data into a Cloud SQL instance from a MySQL dump file in Google Cloud Storage
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/import

      class Real
        def import_instance(instance_id, uri, options = {})
          api_method = @sql.instances.import
          parameters = {
            "project" => @project,
            "instance" => instance_id
          }

          body = {
            "importContext" => {
              "kind" => 'sql#importContext',
              "uri" => Array(uri),
              "database" => options[:database]
            }
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def import_instance(instance_id, _uri, _options = {})
          operation = random_operation
          data[:operations][instance_id] ||= {}
          data[:operations][instance_id][operation] = {
            "kind" => 'sql#instanceOperation',
            "instance" => instance_id,
            "operation" => operation,
            "operationType" => "IMPORT",
            "state" => Fog::Google::SQL::Operation::DONE_STATE,
            "userEmailAddress" => "google_client_email@developer.gserviceaccount.com",
            "enqueuedTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "endTime" => Time.now.iso8601
          }

          body = {
            "kind" => 'sql#instancesImport',
            "operation" => operation
          }

          build_excon_response(body)
        end
      end
    end
  end
end
