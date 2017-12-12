module Fog
  module DNS
    class Google
      ##
      # Atomically updates a ResourceRecordSet collection.
      #
      # @see https://cloud.google.com/dns/api/v1/changes/create
      class Real
        def create_change(zone_name_or_id, additions = [], deletions = [])
          body = {
            "additions" => additions,
            "deletions" => deletions
          }
          @dns.create_change(@project, zone_name_or_id, body)
        end
      end

      class Mock
        def create_change(_zone_name_or_id, _additions = [], _deletions = [])
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
