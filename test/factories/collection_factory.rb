class CollectionFactory
  def initialize
    @resources = []
  end

  def cleanup
    @resources.each { |r| r.destroy }
    @resources.each do |r|
      Fog.wait_for { !@subject.all.map(&:identity).include? r.identity }
    end
  end

  def create
    @resources << resource = @subject.create(params)
    return resource
  end
end
