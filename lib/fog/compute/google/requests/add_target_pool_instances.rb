module Fog
  module Compute
    class Google
      class Mock
        def add_target_pool_instances(_target_pool, _region, _instances)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_target_pool_instances(target_pool, region, instances)
          instances_lst = instances.map do |instance|
            ::Google::Apis::ComputeV1::InstanceReference.new(:instance => instance)
          end

          @compute.add_target_pool_instance(
            @project,
            region.split("/")[-1],
            target_pool,
            ::Google::Apis::ComputeV1::AddTargetPoolsInstanceRequest.new(
              :instances => instances_lst
            )
          )
        end
      end
    end
  end
end
