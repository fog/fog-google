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
        # @param source_image [String] Optional self_link or family formatted url of the image to
        # create the disk from, see https://cloud.google.com/compute/docs/reference/latest/disks/insert
        # @param opts [Hash] Optional hash of options
        # @option options [String] size_gb Number of GB to allocate to an empty disk
        # @option options [String] source_snapshot Snapshot to create the disk from
        # @option options [String] description Human friendly description of the disk
        # @option options [String] type URL of the disk type resource describing which disk type to use
        # TODO: change source_image to keyword argument in 2.0 and properly deprecate
        def insert_disk(disk_name, zone, source_image = nil,
                        description: nil, type: nil, size_gb: nil,
                        source_snapshot: nil, **_opts)

          if source_image && !source_image.include?("projects/")
            raise ArgumentError.new("source_image needs to be self-link formatted or specify a family")
          end

          disk = ::Google::Apis::ComputeV1::Disk.new(
            :name => disk_name,
            :description => description,
            :type => type,
            :size_gb => size_gb,
            :source_snapshot => source_snapshot,
            :source_image => source_image
          )
          @compute.insert_disk(@project, zone.split("/")[-1], disk)
        end
      end
    end
  end
end
