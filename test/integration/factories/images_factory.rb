require "integration/factories/collection_factory"

class ImagesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Google::Compute.new.images, example)
  end

  def params
    { :name => resource_name,
      :raw_disk => { :source => TEST_RAW_DISK_SOURCE } }
  end
end
