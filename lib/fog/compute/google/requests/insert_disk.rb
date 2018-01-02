module Fog
  module Compute
    class Google
      class Mock
        def insert_disk(_disk_name, _zone, _image_name = nil, _options = {})
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
        # @option options [String] size_gb Number of GB to allocate to an empty disk
        # @option options [String] source_snapshot Snapshot to create the disk from
        # @option options [String] description Human friendly description of the disk
        # @option options [String] type URL of the disk type resource describing which disk type to use
        def insert_disk(disk_name, zone, image_name = nil,
                        description: nil, type: nil, size_gb: nil,
                        source_snapshot: nil, **_opts)
          disk = ::Google::Apis::ComputeV1::Disk.new(
            :name => disk_name,
            :description => description,
            :type => type,
            :size_gb => size_gb,
            :source_snapshot => source_snapshot
          )
          @compute.insert_disk(@project, zone.split("/")[-1], disk,
                               :source_image => image_name)
        end
      end
    end
  end
end
