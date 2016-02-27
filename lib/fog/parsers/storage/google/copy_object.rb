module Fog
  module Parsers
    module Storage
      module Google
        class CopyObject < Fog::Parsers::Base
          def end_element(name)
            case name
            when "ETag"
              @response[name] = value.delete('"')
            when "LastModified"
              @response[name] = Time.parse(value)
            end
          end
        end
      end
    end
  end
end
