module Fog
  module Compute
    class Google
      class Mock
        def get_server(server_name, zone_name)
          server = data[:servers][server_name]
          get_zone(zone_name)
          zone = data[:zones][zone_name]
          if server.nil? || server["zone"] != zone["selfLink"]
            return build_excon_response("error" => {
                                          "errors" => [
                                            {
                                              "domain" => "global",
                                              "reason" => "notFound",
                                              "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/instances/#{server_name}' was not found"
                                            }
                                          ],
                                          "code" => 404,
                                          "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/instances/#{server_name}' was not found"
                                        })
          end

          # transition the server through the provisioning -> staging -> running states
          creation_time = Time.iso8601(server["creationTimestamp"])
          case server["status"]
          when "PROVISIONING"
            if Time.now - creation_time > Fog::Mock.delay / 2
              server["status"] = "STAGING"
            end
          when "STAGING"
            if Time.now - creation_time > Fog::Mock.delay
              server["status"] = "RUNNING"
            end
          when "STOPPED"
            if server["mock-deletionTimestamp"]
              # stopped -> terminated
              if Time.now - Time.iso8601(server["mock-deletionTimestamp"]) > Fog::Mock.delay
                server["status"] = "TERMINATED"
              end
            end
          when "TERMINATED"
            if Time.now - Time.iso8601(server["mock-deletionTimestamp"]) > Fog::Mock.delay
              data[:servers][server_name] = nil
            end
          end

          build_excon_response(server)
        end
      end

      class Real
        def get_server(server_name, zone_name)
          zone = if zone_name.is_a? Excon::Response
                   zone_name.body["name"]
                 else
                   zone_name
                 end

          api_method = @compute.instances.get
          parameters = {
            "project" => @project,
            "zone" => zone,
            "instance" => server_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
