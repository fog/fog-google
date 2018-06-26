require "integration/factories/collection_factory"

class FirewallsFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].firewalls, example)
  end

  def params
    { :name => resource_name,
      :allowed => [{ :ip_protocol => "TCP",
                     :ports => ["201"] }] }
  end
end
