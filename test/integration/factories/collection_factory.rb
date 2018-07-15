class CollectionFactory
  PREFIX = "fog-test".freeze

  def initialize(subject, example)
    @subject = subject
    @example = example
    @resource_counter = 0
  end

  def cleanup(async = false)
    # Grab the test suit name from the example
    suit_name = [@example].join("_").gsub(/\W/, "").tr("_", "-").downcase.split('-')[0]
    # Select all resources matching the test suite
    resources = @subject.all.select { |resource| resource.name.match? /#{PREFIX}-[0-9]*-#{suit_name}/ }
    resources.each { |r| r.destroy(async) }
    resources.each { |r| Fog.wait_for { !@subject.all.map(&:identity).include? r.identity } }
  end

  # Creates a collection object instance e.g. Fog::Compute::Google::Server
  #
  # @param [Hash] custom_params - override factory creation parameters or provide
  #   additional ones. Useful in tests where you need to create a slightly different
  #   resource than the default one but still want to take advantage of the factory's
  #   cleanup methods, etc.
  #
  # @example Create a custom factory
  #   @factory = ServersFactory.new(namespaced_name)
  #   server = @factory.create(:machine_type => "f1-micro")
  #
  # @return [Object] - collection object instance
  def create(custom_params = {})
    @subject.create(params.merge(custom_params))
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
