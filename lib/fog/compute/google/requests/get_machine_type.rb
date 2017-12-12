module Fog
  module Compute
    class Google
      class Mock
        def get_machine_type(_machine_type, _zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_machine_type(machine_type, zone)
          zone = zone.split("/")[-1] if zone.start_with? "http"
          @compute.get_machine_type(@project, zone, machine_type)
        end
      end
    end
  end
end
