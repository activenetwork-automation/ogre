require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

describe Ogre::SetPrivateKey do

  VCR.configure do |config|
    config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    config.hook_into :webmock

    # remove sensitive authentication information from the recording
    config.before_record do |interaction|
      headers = interaction.request.headers
      headers.keys.
        select { |k| k =~ /^X-Ops-(Authorization-|Content-Hash)/ }.
        each { |header| headers[header] = Array("{{#{header}}}") }
      headers["X-Ops-Userid"] = "pivotal"
    end
  end

  it 'set private key via vco workflow' do
    args = %w(chef.server org-validator spec/fixtures/client_key/dummy.pem --vco-url https://vco.server:8281/ --vco-user user --vco-password password  --vco-wf-name Set-Private-Key)
    VCR.use_cassette("set-private-key", :match_requests_on => [:uri]) do
      options = Ogre::SetPrivateKey.start(args)
    end
  end

end

#rubocop:enable LineLength
