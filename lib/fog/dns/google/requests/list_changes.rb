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
        def list_changes(_zone_name_or_id)
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
