require 'fog/core/collection'
require 'fog/google/models/compute/instance_group'

module Fog
  module Compute
    class Google
      class InstanceGroups < Fog::Collection
        model Fog::Compute::Google::InstanceGroup

        def all
          data = service.list_instance_groups.body
          load(data['items'] || [])
        end

        def get(identity)
          ##if network = service.get_network(identity).body
          ##  new(network)
          ##end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
