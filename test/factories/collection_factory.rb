class CollectionFactory
  def initialize
    @resources = []
  end

  def cleanup
    @resources.each { |r| r.destroy }
  end

  def create
    @resources << resource = @subject.create(params)
    return resource
  end
end
