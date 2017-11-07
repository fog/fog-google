module Fog
  module Compute
    class Google
      class Mock
        def get_route(_identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # List address resources in the specified project
        #
        # @see https://cloud.google.com/compute/docs/reference/latest/routes/list
        def get_route(identity)
          @compute.get_route(@project, identity)
        end
      end
    end
  end
end
