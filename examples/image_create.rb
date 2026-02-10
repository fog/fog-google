def test
  connection = Fog::Compute.new(:provider => "Google")

  rawdisk = {
    # Google Cloud Storage URL pointing to the disk image. (e.g. http://storage.googleapis.com/test/test.tar.gz)
    :source => nil,
    :container_type => "TAR"
  }

  # Can't test this unless the 'source' points to a valid URL
  return if rawdisk[:source].nil?

  img = connection.images.create(:name => "test-image",
                                 :description => "Test image (via fog)",
                                 :raw_disk => rawdisk)

  # will raise if image was not saved correctly
  img.reload
end
