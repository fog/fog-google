module Fog
  module Compute
    class Google
      class Disk < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :zone, :aliases => :zone_name
        attribute :status
        attribute :description
        attribute :size_gb, :aliases => "sizeGb"
        attribute :self_link, :aliases => "selfLink"
        attribute :source_image, :aliases => "sourceImage"
        attribute :source_image_id, :aliases => "sourceImageId"
        attribute :source_snapshot, :aliases => "sourceSnapshot"
        attribute :source_snapshot_id, :aliases => "sourceSnapshotId"
        attribute :type

        def default_description
          if !source_image.nil?
            "created from image: #{source_image}"
          elsif !source_snapshot.nil?
            "created from snapshot: #{source_snapshot}"
          else
            "created with fog"
          end
        end

        def save
          requires :name, :zone, :size_gb

          options = {
            :description => description || default_description,
            :type => type,
            :size_gb => size_gb,
            :source_image => source_image,
            :source_snapshot => source_snapshot
          }

          if options[:source_image]
            unless source_image.include?("projects/")
              options[:source_image] = service.images.get(source_image).self_link
            end
          end

          # Request needs backward compatibility so source image is specified in
          # method arguments
          data = service.insert_disk(name, zone, options[:source_image], options)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, data.zone)
          operation.wait_for { ready? }
          reload
        end

        def destroy(async = true)
          requires :name, :zone

          data = service.delete_disk(name, zone_name)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, data.zone)
          operation.wait_for { ready? } unless async
          operation
        end

        def zone_name
          zone.nil? ? nil : zone.split("/")[-1]
        end

        def attached_disk_obj(opts = {})
          requires :self_link
          collection.attached_disk_obj(self_link, opts)
        end

        def get_as_boot_disk(writable = true, auto_delete = false)
          {
            :auto_delete => auto_delete,
            :boot => true,
            :source => self_link,
            :mode =>  writable ? "READ_WRITE" : "READ_ONLY",
            :type => "PERSISTENT"
          }
        end

        def ready?
          status == RUNNING_STATE
        end

        def reload
          requires :identity, :zone

          return unless data = begin
            collection.get(identity, zone_name)
          rescue Google::Apis::TransmissionError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        def create_snapshot(snapshot_name, snapshot = {})
          requires :name, :zone
          raise ArgumentError, "Invalid snapshot name" unless snapshot_name

          data = service.create_disk_snapshot(snapshot_name, name, zone_name, snapshot)
          operation = Fog::Compute::Google::Operations.new(:service => service)
                                                      .get(data.name, data.zone)
          operation.wait_for { ready? }
          service.snapshots.get(snapshot_name)
        end

        RUNNING_STATE = "READY".freeze
      end
    end
  end
end
