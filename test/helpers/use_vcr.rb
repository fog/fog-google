module UseVCR
  VCR_RECORDING_INTERVAL = 10
  VCR_PLAYBACK_INTERVAL = 0

  def before_setup
    super
    VCR.insert_cassette(namespaced_name)
    @default_fog_interval = Fog.interval
    Fog.interval = VCR.current_cassette.recording? ? VCR_RECORDING_INTERVAL : VCR_PLAYBACK_INTERVAL
  end

  def after_teardown
    Fog.interval = @default_fog_interval
    VCR.eject_cassette
    super
  end
end
