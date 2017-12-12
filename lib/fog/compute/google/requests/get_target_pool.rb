module Fog
  module Compute
    class Google
      class Mock
        def get_target_pool(_target_pool, _region)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_pool(target_pool, region)
          region = region.split("/")[-1] if region.start_with? "http"
          @compute.get_target_pool(@project, region, target_pool)
        end
      end
    end
  end
end
