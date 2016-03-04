module Fog
  module Compute
    class Google
      # the resource view model creates either a region view or zone view depending on which is parameter is passed
      class ResourceView < Fog::Model
        identity :name

        attribute :kind, :aliases => "kind"
        attribute :self_link, :aliases => "selfLink"
        attribute :id, :aliases => "id"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :description, :aliases => "description"
        attribute :region, :aliases => "region" # string, required for region views
        attribute :labels, :aliases => "labels" # array of hashes including 'key' and 'value' as keys
        attribute :zone, :aliases => "zone" # string, required for zone views
        attribute :last_modified, :aliases => "lastModified"
        attribute :members, :aliases => "members" # array of members of resource view
        attribute :num_members, :aliases => "numMemebers" # integer

        def save
          requires :name
          labels ||= []
          members ||= []

          if region
            options = {
              "description" => description,
              "labels" => labels,
              "lastModified" => last_modified,
              "members" => members,
              "numMembers" => num_members
            }
            @region = region
            data = service.insert_region_view(name, region, options).body
            operation = service.get_region_view(data["resource"]["name"], nil, @region).body
          end

          if zone
            options = {
              "description" => description,
              "labels" => labels,
              "lastModified" => last_modified,
              "members" => members,
              "numMembers" => num_members
            }
            @zone = zone
            data = service.insert_zone_view(name, zone, options).body
            operation = service.get_zone_view(data["resource"]["name"], @zone).body
          end
          reload
        end

        def destroy(async = false)
          requires :name
          # parse the self link to get the zone or region
          selflink = self_link.split("/")
          if selflink[7] == "regions"
            operation = service.delete_region_view(name, selflink[8])
          end

          if selflink[7] == "zones"
            operation = service.delete_zone_view(name, selflink[8])
          end

          unless async
            # wait until "DONE" to ensure the operation doesn't fail, raises
            # exception on error
            Fog.wait_for do
              operation.body.nil?
            end
          end
          operation
        end

        def add_resources(resources)
          resources = [resources] unless resources.class == Array
          resources.map { |resource| resource.class == String ? resource : resource.self_link }
          service.add_zone_view_resources(self, resources, @zone) if @zone
          service.add_region_view_resources(self, reources, @region) if @region
          reload
        end

        def ready?
          service.get_zone_view(name, @zone) if @zone
          service.get_region_view(name, @region) if @region
          true
        rescue Fog::Errors::NotFound
          false
        end

        def reload
          requires :name

          return unless data = begin
            collection.get(name, region, zone)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end
        RUNNING_STATE = "READY"
      end
    end
  end
end
