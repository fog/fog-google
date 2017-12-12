module Fog
  module Compute
    class Google
      class Mock
        def set_server_scheduling(_identity, _zone, _on_host_maintenance, _automatic_restart, _preemptible)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_server_scheduling(identity, zone, on_host_maintenance: nil, automatic_restart: nil, preemptible: nil)
          scheduling = ::Google::Apis::ComputeV1::Scheduling.new(
            :on_host_maintenance => on_host_maintenance,
            :automatic_restart => automatic_restart,
            :preemptible => preemptible
          )
          zone = zone.split("/")[-1]
          @compute.set_instance_scheduling(@project, zone, identity, scheduling)
        end
      end
    end
  end
end
