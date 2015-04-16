require "factories/collection_factory"

class HttpHealthChecksFactory < CollectionFactory
  def initialize
    super
    @subject = Fog::Compute[:google].http_health_checks
  end

  def params
    {:name => create_test_name}
  end
end
