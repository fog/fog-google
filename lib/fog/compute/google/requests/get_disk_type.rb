module Fog
  module Compute
    class Google
      class Mock
        def get_disk_type(_disk, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_disk_type(disk, zone)
          @compute.get_disk_type(@project, zone.split("/")[-1], disk)
        end
      end
    end
  end
end
