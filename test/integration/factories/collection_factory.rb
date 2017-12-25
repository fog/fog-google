class CollectionFactory
  PREFIX = "fog-test".freeze

  def initialize(subject, example)
    @subject = subject
    @example = example
    @resource_counter = 0
  end

  def cleanup(async = true)
    resources = @subject.all.select { |resource| resource.name.start_with? PREFIX }
    resources.each { |r| r.destroy(async) }
    resources.each { |r| Fog.wait_for { !@subject.all.map(&:identity).include? r.identity } }
  end

  def create
    @subject.create(params)
  end

  def get(identity)
    @subject.get(identity)
  end

  def resource_name(base = @example, prefix = PREFIX)
    index = @resource_counter += 1
    # In prefix, convert - to _ to make sure that it doesn't get stripped by the \W strip below.
    # Then, concatenate prefix, index, and base; strip all non-alphanumerics except _;
    # convert _ to -; downcase; truncate to 62 characters; delete trailing -
    [prefix.tr("-", "_"), index, base].join("_").gsub(/\W/, "").tr("_", "-").downcase[0..61].chomp("-")
  end
end
