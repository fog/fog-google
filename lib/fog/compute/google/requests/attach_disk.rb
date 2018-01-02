module Fog
  module Compute
    class Google
      class Mock
        def attach_disk(_instance, _zone, _disk = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def attach_disk(instance, zone, disk = {})
          @compute.attach_disk(
            @project, zone.split("/")[-1], instance,
            ::Google::Apis::ComputeV1::AttachedDisk.new(disk)
          )
        end
      end
    end
  end
end
