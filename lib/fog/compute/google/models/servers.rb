module Fog
  module Compute
    class Google
      class Servers < Fog::Collection
        model Fog::Compute::Google::Server

        def all(zone: nil, filter: nil, max_results: nil,
                order_by: nil, page_token: nil)
          opts = {
            :filter => filter,
            :max_results => max_results,
            :order_by => order_by,
            :page_token => page_token
          }

          if zone
            data = service.list_servers(zone, opts).to_h[:items] || []
          else
            data = []
            service.list_aggregated_servers(opts).items.each_value do |scoped_lst|
              if scoped_lst && scoped_lst.instances
                data.concat(scoped_lst.instances.map(&:to_h))
              end
            end
          end
          load(data)
        end

        def get(identity, zone = nil)
          response = nil
          if zone
            response = service.get_server(identity, zone).to_h
          else
            server = all(:filter => "name eq .*#{identity}").first
            response = server.attributes if server
          end
          return nil if response.nil?
          new(response)
        rescue ::Google::Api::ClientError => e
          raise e unless e.status_code == 404
          nil
        end

        def bootstrap(public_key_path = "~/.ssh/id_rsa.pub", opts = {})
          name = "fog-#{Time.now.to_i}"
          zone_name = "us-central1-f"

          disks = opts[:disks]

          if disks.nil? || disks.empty?
            # create the persistent boot disk
            source_img = service.images.get_from_family("debian-8")
            disk_defaults = {
              :name => name,
              :size_gb => 10,
              :zone_name => zone_name,
              :source_image => source_img.self_link
            }
            disk = service.disks.create(disk_defaults.merge(opts))
            disk.wait_for { disk.ready? }

            disks = [disk]
          end

          data = opts.merge(
            :name => name,
            :zone => zone_name,
            :disks => disks
          )
          data[:machine_type] = "n1-standard-1" unless data[:machine_type]

          public_key = File.read(File.expand_path(public_key_path))
          user = ENV["USER"]

          server = new(data)
          server.save(:username => user, :public_key => public_key)

          # TODO: I don't think this is currently possible - remove or enable.
          # server.wait_for { sshable? }
          server
        end
      end
    end
  end
end
