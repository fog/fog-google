module Fog
  module Compute
    class Google
      class Addresses < Fog::Collection
        model Fog::Compute::Google::Address

        def all(region: nil, filter: nil, max_results: nil, order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if region
            data = service.list_addresses(region, opts).items || []
          else
            data = []
            service.list_aggregated_addresses(opts).items.each_value do |scoped_list|
              data.concat(scoped_list.addresses) if scoped_list && scoped_list.addresses
            end
          end
          load(data.map(&:to_h))
        end

        def get(identity, region = nil)
          if region
            address = service.get_address(identity, region).to_h
            return new(address)
          elsif identity
            response = all(:filter => "name eq #{identity}",
                           :max_results => 1)
            address = response.first unless response.empty?
            return address
          end
        rescue ::Google::Apis::ClientError => e
          raise e unless e.status_code == 404
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
