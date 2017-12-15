module Fog
  module Compute
    class Google
      class Mock
        def set_server_tags(_instance, _zone, _tags = [])
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_server_tags(instance, zone, fingerprint, tags = [])
          @compute.set_instance_tags(
            @project, zone.split("/")[-1], instance,
            ::Google::Apis::ComputeV1::Tags.new(
              :fingerprint => fingerprint,
              :items => tags
            )
          )
        end
      end
    end
  end
end
