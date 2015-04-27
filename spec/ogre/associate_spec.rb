require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

describe Ogre::Associate do

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

  it 'should associate user to org' do
    args = %w(my-org-name test --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette("associate", :match_requests_on => [:uri]) do
      options = Ogre::Associate.start(args)
    end
  end

  it 'should associate user to users and admin group' do
    args = %w(my-org-name test -a --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette("associate", :match_requests_on => [:uri]) do
      options = Ogre::Associate.start(args)
    end
  end

end

#rubocop:enable LineLength
