module Fog
  module Compute
    class Google
      class Mock
        def get_target_pool_health(_target_pool, _instance)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_pool_health(target_pool, instance = nil)
          api_method = @compute.target_pools.get_health
          parameters = {
            "project" => @project,
            "targetPool" => target_pool.name,
            "region" => target_pool.region.split("/")[-1]
          }

          if instance
            body = { "instance" => instance }
            resp = request(api_method, parameters, body_object = body)
            [instance, resp.data[:body]["healthStatus"]]
          else
            # TODO: Remove (introduced after 0.4.2)
            Fog::Logger.deprecation(
              "Do not use raw requests, use Fog::Compute::Google::TargetPool.get_health instead [light_black](#{caller.first})[/]"
            )
            health_results = target_pool.instances.map do |instance_object|
              body = { "instance" => instance_object }
              resp = request(api_method, parameters, body_object = body)
              [instance_object, resp.data[:body]["healthStatus"]]
            end
            Hash[health_results]
          end
        end
      end
    end
  end
end
