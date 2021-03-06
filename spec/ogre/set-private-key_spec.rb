require_relative '../spec_helper.rb'
require 'ogre'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

describe Ogre::SetPrivateKey do
  it 'should set private key via vco workflow' do
    args = %w(chef.server org-validator spec/fixtures/client_key/dummy.pem) + VCO_DEFAULTS
    VCR.use_cassette('set-private-key', match_requests_on: [:uri]) do
      expect { Ogre::SetPrivateKey.start(args) }.to output(/State:             completed/).to_stdout
    end
  end
end
