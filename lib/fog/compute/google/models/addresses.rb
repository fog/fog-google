module Fog
  module Compute
    class Google
      class Addresses < Fog::Collection
        model Fog::Compute::Google::Address

        def all(filters = {})
          if filters[:region]
            data = service.list_addresses(filters[:region]).items || []
          else
            data = []
            service.list_aggregated_addresses.items.each_value do |region|
              data.concat(region.addresses) if region.addresses
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, region)
          if address = service.get_address(identity, region).to_h
            new(address)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def get_by_ip_address(ip_address)
          addresses = service.list_aggregated_addresses(:filter => "address eq .*#{ip_address}").items
          address = addresses.each_value.select(&:addresses)

          return nil if address.empty?
          new(address.first.addresses.first.to_h)
        end

        def get_by_name(ip_name)
          names = service.list_aggregated_addresses(:filter => "name eq .*#{ip_name}").items
          name = names.each_value.select(&:addresses)

          return nil if name.empty?
          new(name.first.addresses.first.to_h)
        end

        def get_by_ip_address_or_name(ip_address_or_name)
          get_by_ip_address(ip_address_or_name) || get_by_name(ip_address_or_name)
        end
      end
    end
  end
end
