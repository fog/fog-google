module UseVCR
  def before_setup
    super
    VCR.insert_cassette("#{self.class.to_s}_#{name}")
  end

  def after_teardown
    VCR.eject_cassette
    super
  end
end
