class CollectionFactory
  def initialize(subject, example)
    @subject = subject
    @example = example
    @resources = []
    @num_resources = 0
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

  def resource_name(base=@example, prefix="fog")
    index = @num_resources += 1
    ([prefix, base, index] * "-").gsub(/_/, '-').downcase[0..61]
  end
end
