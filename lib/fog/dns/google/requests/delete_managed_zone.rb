module Fog
  module DNS
    class Google
      ##
      # Deletes a previously created Managed Zone.
      #
      # @see https://developers.google.com/cloud-dns/api/v1/managedZones/delete
      class Real
        def delete_managed_zone(name_or_id)
          @dns.delete_managed_zone(@project, name_or_id)
        end
      end

      class Mock
        def delete_managed_zone(_name_or_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
