module Fog
  module DNS
    class Google
      ##
      # Enumerates Managed Zones that have been created but not yet deleted.
      #
      # @see hhttps://developers.google.com/cloud-dns/api/v1/managedZones/list
      class Real
        def list_managed_zones
          @dns.list_managed_zones(@project)
        end
      end

      class Mock
        def list_managed_zones
          raise Fog::Errors::MockNotImplemented
        end
      end
    end
  end
end
