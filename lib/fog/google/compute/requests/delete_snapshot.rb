module Fog
  module Google
    class Compute
      class Mock
        def delete_snapshot(_snapshot_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_snapshot(snapshot_name)
          @compute.delete_snapshot(@project, snapshot_name)
        end
      end
    end
  end
end
