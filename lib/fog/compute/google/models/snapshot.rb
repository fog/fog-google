module Fog
  module Compute
    class Google
      class Snapshot < Fog::Model
        identity :name

        attribute :kind
        attribute :self_link, :aliases => "selfLink"
        attribute :creation_timestamp, :aliases => "creationTimestamp"
        attribute :disk_size_gb, :aliases => "diskSizeGb"
        attribute :source_disk, :aliases => "sourceDisk"
        attribute :source_disk_id, :aliases => "sourceDiskId"
        attribute :description
        attribute :status
        attribute :id
        attribute :storage_bytes, :aliases => "storageBytes"
        attribute :storage_bytes_status, :aliases => "storageBytesStatus"

        CREATING_STATE  = "CREATING".freeze
        DELETING_STATE  = "DELETING".freeze
        FAILED_STATE    = "FAILED".freeze
        READY_STATE     = "READY".freeze
        UPLOADING_STATE = "UPLOADING".freeze

        def destroy(async = true)
          requires :identity

          data = service.delete_snapshot(identity)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body["name"])
          operation.wait_for { ready? } unless async
          operation
        end

        def ready?
          status == READY_STATE
        end

        def resource_url
          "#{service.project}/global/snapshots/#{name}"
        end
      end
    end
  end
end
