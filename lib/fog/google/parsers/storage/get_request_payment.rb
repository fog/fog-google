module Fog
  module Google
    module Parsers
      module Storage
        class GetRequestPayment < Fog::Parsers::Base
          def end_element(name)
            case name
            when "Payer"
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
