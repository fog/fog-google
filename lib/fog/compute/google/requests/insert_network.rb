module Fog
  module Compute
    class Google
      class Mock
        def insert_network(_network_name, _opts = {})
          # :no-coverage:
          Fog::Mock.not_implemented
          # :no-coverage:
        end
      end

      class Real
        INSERTABLE_NETWORK_FIELDS = %i{
          auto_create_subnetworks
          description
          gateway_i_pv4
          i_pv4_range
          name
          routing_config
        }.freeze

        def insert_network(network_name, opts = {})
          opts = opts.select { |k, _| INSERTABLE_NETWORK_FIELDS.include? k }
                     .merge(:name => network_name)

          @compute.insert_network(
            @project,
            ::Google::Apis::ComputeV1::Network.new(**opts)
          )
        end
      end
    end
  end
end
