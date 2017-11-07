module Fog
  module Compute
    class Google
      class Mock
        def insert_disk(_disk_name, _zone_name, _image_name = nil, _options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Create a disk resource in a specific zone
        # https://cloud.google.com/compute/docs/reference/latest/disks/insert
        #
        # @param disk_name [String] Name of the disk to create
        # @param zone_name [String] Zone the disk reside in
        # @param image_name [String] Optional image name to create the disk from
        # @param opts [Hash] Optional hash of options
        # @option options [String] "sizeGb" Number of GB to allocate to an empty disk
        # @option options [String] "sourceSnapshot" Snapshot to create the disk from
        # @option options [String] "description" Human friendly description of the disk
        # @option options [String] "type" URL of the disk type resource describing which disk type to use
        def insert_disk(disk_name, zone_name, image_name = nil, opts = {})
          # According to Google docs, if image name is not present, only one of
          # sizeGb or sourceSnapshot need to be present, one will create blank
          # disk of desired size, other will create disk from snapshot
          if image_name.nil? && opts["sizeGb"].nil? && opts["sourceSnapshot"].nil?
            raise ArgumentError.new("Must specify image OR snapshot OR "\
                                    "disk size when creating a disk.")
          end

          disk = ::Google::Apis::ComputeV1::Disk.new(
            :name => disk_name,
            :description => opts["description"],
            :type => opts["type"],
            :size_gb => opts["sizeGb"],
            :source_snapshot => opts["sourceSnapshot"]
          )
          @compute.insert_disk(@project, zone_name, disk,
                               :source_image => image_name)
        end
      end
    end
  end
end
