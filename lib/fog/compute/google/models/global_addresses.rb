module Fog
  module Compute
    class Google
      class GlobalAddresses < Fog::Collection
        model Fog::Compute::Google::GlobalAddress

        def all(options = {})
          data = service.list_global_addresses(options).to_h[:items] || []
          load(data)
        end

        def get(identity)
          if identity
            address = service.get_global_address(identity).to_h
            return new(address)
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        def get_by_ip_address(ip_address)
          data = service.list_global_addresses(:filter => "address eq #{ip_address}")
          if data.nil? || data.items.nil?
            nil
          else
            new(data.items.first.to_h)
          end
        end

        def get_by_name(ip_name)
          data = service.list_global_addresses(:filter => "name eq #{ip_name}")
          if data.nil? || data.items.nil?
            nil
          else
            new(data.items.first.to_h)
          end
        end

        def get_by_ip_address_or_name(ip_address_or_name)
          get_by_ip_address(ip_address_or_name) || get_by_name(ip_address_or_name)
        end
      end
    end
  end
end
