require "integration/factories/collection_factory"

class SslCertificatesFactory < CollectionFactory
  def initialize(example)
    super(Fog::Compute[:google].ssl_certificates, example)
  end

  def params
    { :name => resource_name,
      :certificate => TEST_PEM_CERTIFICATE,
      :private_key => TEST_PEM_CERTIFICATE_PRIVATE_KEY }
  end
end
