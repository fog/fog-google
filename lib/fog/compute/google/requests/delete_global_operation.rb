module Fog
  module Compute
    class Google
      class Mock
        def delete_global_operation(_operation)
          Fog::Mock.not_implemented
        end
      end

      class Real
        # @see https://developers.google.com/compute/docs/reference/latest/globalOperations/delete
        def delete_global_operation(operation)
          @compute.delete_global_operation(@project, operation)
        end
      end
    end
  end
end
