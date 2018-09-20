require "integration/factories/collection_factory"

class ImagesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].images, example)
  end

  def get(identity)
    @subject.get(identity, TEST_PROJECT)
  end

  def params
    { :name => resource_name,
      :raw_disk => { :source => TEST_RAW_DISK_SOURCE } }
  end
end
