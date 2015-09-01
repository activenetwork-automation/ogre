require_relative '../spec_helper.rb'
require 'ogre'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

describe Ogre::SetPrivateKey do
  before(:each) do
    @url = 'https://vco.server:8281/'
    @username = 'user'
    @password = 'password'

    @config_file = "#{ENV['HOME']}/.vcoworkflows/config.json"
    @config_data = {
      url: @url,
      username: @username,
      password: @password
    }.to_json

    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(@config_file).and_return(@config_data)
  end

  it 'should set private key via vco workflow' do
    args = %w(chef.server org-validator spec/fixtures/client_key/dummy.pem) + VCO_DEFAULTS
    VCR.use_cassette('set-private-key', match_requests_on: [:uri]) do
      expect { Ogre::SetPrivateKey.start(args) }.to output(/State:             completed/).to_stdout
    end
  end
end
