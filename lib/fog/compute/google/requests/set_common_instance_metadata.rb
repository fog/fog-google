module Fog
  module Compute
    class Google
      class Mock
        def set_common_instance_metadata(_project, _current_fingerprint, _metadata = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_common_instance_metadata(project, current_fingerprint, metadata = {})
          metadata_obj = ::Google::Apis::ComputeV1::Metadata.new(
            :fingerprint => current_fingerprint,
            :items => metadata.map { |k, v| { :key => k, :value => v } }
          )
          @compute.set_common_instance_metadata(project, metadata_obj)
        end
      end
    end
  end
end
