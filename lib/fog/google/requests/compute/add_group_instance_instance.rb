module Fog
  module Compute
    class Google
      class Mock
        def add_group_instance_instance(group_name, zone_name, instance_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_group_instance_instance(group_name, zone_name, instances)
          api_method = @compute.addInstances.patch
          parameters = {
            'project' => @project,
            'backendService' => backend_service.name,
          }
          if backend_service.backends then
            backend_service.backends.concat(new_backends)
          else
            backend_service.backends = new_backends
          end
          body_object = backend_service

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
