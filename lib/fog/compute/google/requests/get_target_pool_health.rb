module Fog
  module Compute
    class Google
      class Mock
        def get_target_pool_health(_target_pool, _region, _instance)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_pool_health(target_pool, region, instance)
          @compute.get_target_pool_health(
            @project, region.split("/")[-1], target_pool,
            ::Google::Apis::ComputeV1::InstanceReference.new(
              :instance => instance
            )
          )
        end
      end
    end
  end
end
