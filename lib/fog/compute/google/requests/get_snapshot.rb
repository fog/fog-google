module Fog
  module Compute
    class Google
      class Mock
        def get_snapshot(_snap_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_snapshot(snap_name, project = @project)
          raise ArgumentError.new "snap_name must not be nil." if snap_name.nil?

          api_method = @compute.snapshots.get
          parameters = {
            "snapshot" => snap_name,
            "project"  => project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
