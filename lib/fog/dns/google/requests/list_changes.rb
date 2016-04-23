module Fog
  module DNS
    class Google
      ##
      # Enumerates the list of Changes.
      #
      # @see https://developers.google.com/cloud-dns/api/v1/changes/list
      class Real
        def list_changes(zone_name_or_id)
          api_method = @dns.changes.list
          parameters = {
            "project" => @project,
            "managedZone" => zone_name_or_id
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_changes(zone_name_or_id)
          zone = if data[:managed_zones].key?(zone_name_or_id)
                   data[:managed_zones][zone_name_or_id]
                 else
                   data[:managed_zones].values.detect { |z| z["name"] == zone_name_or_id }
                 end

          unless zone
            raise Fog::Errors::NotFound, "The 'parameters.managedZone' resource named '#{zone_name_or_id}' does not exist."
          end

          body = {
            "kind" => 'dns#changesListResponse',
            "changes" => data[:changes][zone["id"]]
          }
          build_excon_response(body)
        end
      end
    end
  end
end
