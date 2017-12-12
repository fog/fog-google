module Fog
  module Compute
    class Google
      class Mock
        def set_snapshot_labels(_snap_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_snapshot_labels(snap_name, label_fingerprint, labels)
          @compute.set_snapshot_labels(
            project, snap_name,
            ::Google::Apis::ComputeV1::GlobalSetLabelsRequest.new(
              :label_fingerprint => label_fingerprint,
              :labels => labels
            )
          )
        end
      end
    end
  end
end
