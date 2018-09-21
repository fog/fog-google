require "integration/factories/collection_factory"
require "integration/factories/url_maps_factory"
require "integration/factories/ssl_certificates_factory"

class TargetHttpsProxiesFactory < CollectionFactory
  def initialize(example)
    @ssl_certificates = SslCertificatesFactory.new(example)
    @url_maps = UrlMapsFactory.new(example)
    super(Fog::Compute[:google].target_https_proxies, example)
  end

  def cleanup
    # Calling CollectionFactory#cleanup with forced async as
    # Url Maps need the Https Proxy to be deleted before they
    # can be destroyed
    super(false)
    @ssl_certificates.cleanup
    @url_maps.cleanup
  end

  def params
    { :name => resource_name,
      :url_map => @url_maps.create.self_link,
      :ssl_certificates => [@ssl_certificates.create.self_link] }
  end
end
