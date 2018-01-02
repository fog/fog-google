module Fog
  module Compute
    class Google
      class Mock
        def delete_route(_identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Deletes the specified Route resource.
        #
        # @param identity [String] Name of the route to delete
        # @see https://cloud.google.com/compute/docs/reference/latest/routes/delete
        def delete_route(identity)
          @compute.delete_route(@project, identity)
        end
      end
    end
  end
end
