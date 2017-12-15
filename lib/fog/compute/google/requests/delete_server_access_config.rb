module Fog
  module Compute
    class Google
      class Mock
        def delete_server_access_config(_identity, _zone, _nic, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_server_access_config(identity, zone, nic,
                                        access_config = "External NAT")
          @compute.delete_instance_access_config(
            @project, zone.split("/")[-1], identity, access_config, nic
          )
        end
      end
    end
  end
end
