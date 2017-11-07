module Fog
  module Compute
    class Google
      class Mock
        def list_disks(_zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # List disk resources in the specified zone
        # https://cloud.google.com/compute/docs/reference/latest/disks/list
        #
        # @param zone_name [String] Zone to list disks from
        def list_disks(zone_name)
          @compute.list_disks(@project, zone_name)
        end
      end
    end
  end
end
