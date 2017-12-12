module Fog
  module Compute
    class Google
      class Mock
        def insert_target_pool(_target_pool_name, _region, _target_pool = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_target_pool(target_pool_name, region, target_pool = {})
          pool_obj = ::Google::Apis::ComputeV1::TargetPool.new(
            target_pool.merge(:name => target_pool_name)
          )
          @compute.insert_target_pool(@project, region.split("/")[-1], pool_obj)
        end
      end
    end
  end
end
