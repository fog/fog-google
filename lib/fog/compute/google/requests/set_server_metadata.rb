module Fog
  module Compute
    class Google
      class Mock
        def set_server_metadata(_instance, _zone, _fingerprint, _metadata_items = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        # Set an instance metadata
        #
        # @param [String] instance Instance name (identity)
        # @param [String] zone Name of zone
        # @param [String] fingerprint The fingerprint of the last metadata.
        #   Can be retrieved by reloading the compute object, and checking the
        #   metadata fingerprint field.
        #     instance.reload
        #     fingerprint = instance.metadata['fingerprint']
        # @param [Hash] metadata A new metadata object
        #   Should have the following structure:
        #   {:items=>[{:key=>"foo", :value=>"bar"}, {:key=>"baz", :value=>"foo"}]}
        #
        # @returns [::Google::Apis::ComputeV1::Operation] set operation
        def set_server_metadata(instance, zone, fingerprint, metadata_items = [])
          items = metadata_items.map { |item| ::Google::Apis::ComputeV1::Metadata::Item.new(item) }
          @compute.set_instance_metadata(
            @project, zone.split("/")[-1], instance,
            ::Google::Apis::ComputeV1::Metadata.new(
              :fingerprint => fingerprint, :items => items
            )
          )
        end
      end
    end
  end
end
