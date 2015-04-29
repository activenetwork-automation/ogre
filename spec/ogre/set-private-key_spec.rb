require_relative '../spec_helper.rb'
require 'ogre'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

describe Ogre::SetPrivateKey do
  it 'should set private key via vco workflow' do
    args = %w(chef.server org-validator spec/fixtures/client_key/dummy.pem) + VCO_DEFAULTS
    response = "Execution ID:      some-long-execution-id\n" \
               "Name:              Set-Private-Key\n" \
               "Workflow ID:       some-long-workflow-id\n" \
               "State:             completed\n" \
               "Start Date:        2015-04-27 14:40:01 -0500\n" \
               "End Date:          2015-04-27 14:40:01 -0500\n" \
               "Started By:        user@example.com\n"
    VCR.use_cassette('set-private-key', match_requests_on: [:uri]) do
      expect { Ogre::SetPrivateKey.start(args) }.to output(response).to_stdout
    end
  end
end
