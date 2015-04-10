require 'minitest_helper'

# TODO this is a port over from legacy tests.  It shouldn't be scoped under Fog::Compute::Google, but under Fog::Google::Shared.
describe Fog::Compute::Google do
  describe "using a P12 key file" do
    let(:google_key_location) { Fog.credentials[:google_key_location] }
    let(:google_key_string)   { File.open(File.expand_path(google_key_location), 'rb') { |io| io.read } }

    it "authenticates with key location" do
      c = Fog::Compute::Google.new(:google_key_location => google_key_location,
                                   :google_key_string => nil,
                                   :google_json_key_location => nil,
                                   :google_json_key_string => nil)
      assert_kind_of(Fog::Compute::Google::Real, c)
    end

    it "authenticates with key string" do
      c = Fog::Compute::Google.new(:google_key_location => nil,
                                   :google_key_string => google_key_string,
                                   :google_json_key_location => nil,
                                   :google_json_key_string => nil)
      assert_kind_of(Fog::Compute::Google::Real, c)
    end
  end

  describe "using a JSON key file" do
    let(:google_json_key_location) { Fog.credentials[:google_json_key_location] }
    let(:google_json_key_string)   { File.open(File.expand_path(google_json_key_location), 'rb') { |io| io.read } }

    it "authenticates with key location" do
      c = Fog::Compute::Google.new(:google_key_location => nil,
                                   :google_key_string => nil,
                                   :google_json_key_location => google_json_key_location,
                                   :google_json_key_string => nil)
      assert_kind_of(Fog::Compute::Google::Real, c)
    end

    it "authenticates with key string" do
      c = Fog::Compute::Google.new(:google_key_location => nil,
                                   :google_key_string => nil,
                                   :google_json_key_location => nil,
                                   :google_json_key_string => google_json_key_string)
      assert_kind_of(Fog::Compute::Google::Real, c)
    end
  end

  it 'raises ArgumentError when google_project is missing' do
    assert_raises(ArgumentError) { Fog::Compute::Google.new(:google_project => nil) }
  end

  it 'raises ArgumentError when google_client_email is missing' do
    assert_raises(ArgumentError) { Fog::Compute::Google.new(:google_client_email => nil,
                                                            :google_json_key_location => nil) } # JSON key overrides google_client_email
  end

  it 'raises ArgumentError when no google_keys are given' do
    assert_raises(ArgumentError) { Fog::Compute::Google.new(:google_key_location => nil,
                                                            :google_key_string => nil,
                                                            :google_json_key_location => nil,
                                                            :google_json_key_string => nil) }
  end
end
