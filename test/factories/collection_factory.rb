class CollectionFactory
  def initialize(subject, example)
    @subject = subject
    @example = example
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

  def resource_name(base=@example, prefix="fog")
    ([prefix, base] * "-").gsub(/_/, '-').downcase[0..61]
  end
end
