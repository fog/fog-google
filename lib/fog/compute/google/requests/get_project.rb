module Fog
  module Compute
    class Google
      class Mock
        def get_project(_identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_project(identity)
          @compute.get_project(identity)
        end
      end
    end
  end
end
