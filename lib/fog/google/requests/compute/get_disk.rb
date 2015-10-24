module Fog
  module Compute
    class Google
      class Mock
        def get_disk(disk_name, zone_name)
          disk = data[:disks][disk_name]
          zone_name = zone_name.split("/")[-1] if zone_name.start_with? "http"
          get_zone(zone_name)
          zone = data[:zones][zone_name]
          if disk.nil? || disk["zone"] != zone["selfLink"]
            return build_excon_response("error" => {
                                          "errors" => [
                                            {
                                              "domain" => "global",
                                              "reason" => "notFound",
                                              "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}' was not found"
                                            }
                                          ],
                                          "code" => 404,
                                          "message" => "The resource 'projects/#{@project}/zones/#{zone_name}/disks/#{disk_name}' was not found"
                                        })
          end

          # TODO: transition the disk through the states

          build_excon_response(disk)
        end
      end

      class Real
        def get_disk(disk_name, zone_name)
          zone_name = zone_name.split("/")[-1] if zone_name.start_with? "http"

          api_method = @compute.disks.get
          parameters = {
            "project" => @project,
            "disk" => disk_name,
            "zone" => zone_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
