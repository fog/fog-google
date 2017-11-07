module Fog
  module DNS
    class Google
      ##
      # Enumerates Resource Record Sets that have been created but not yet deleted.
      #
      # @see https://developers.google.com/cloud-dns/api/v1/resourceRecordSets/list
      class Real
        def list_resource_record_sets(zone_name_or_id, options = {})
          api_method = @dns.resource_record_sets.list
          parameters = {
            "project" => @project,
            "managedZone" => zone_name_or_id
          }

          %i(name type).reject { |o| options[o].nil? }.each do |key|
            parameters[key] = options[key]
          end

          request(api_method, parameters)
        end
      end

      class Mock
        def list_resource_record_sets(_zone_name_or_id, _options = {})
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
