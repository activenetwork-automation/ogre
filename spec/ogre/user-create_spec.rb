require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

describe Ogre::UserCreate do

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

  it 'create new user' do
    args = %w(user firstname lastname user@exmaple.com password123 --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette("user-create") do
      options = Ogre::UserCreate.start(args)
    end
  end
end

#rubocop:enable LineLength
