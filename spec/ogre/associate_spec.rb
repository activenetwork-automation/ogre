require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock

  # remove sensitive authentication information from the recording
  config.before_record do |interaction|
    headers = interaction.request.headers
    headers.keys.
      select { |k| k =~ /^X-Ops-(Authorization-|Content-Hash)/ }.
      each { |header| headers[header] = Array("{{#{header}}}") }
    headers['X-Ops-Userid'] = 'pivotal'
  end
end

describe Ogre::Associate do

  it 'should associate user to org' do
    args = %w(my-org-name test) + DEFAULTS
    VCR.use_cassette('associate', match_requests_on: [:uri]) do
      Ogre::Associate.start(args)
    end
  end

  it 'should associate user to users and admin group' do
    args = %w(my-org-name test -a) + DEFAULTS
    VCR.use_cassette('associate', match_requests_on: [:uri]) do
      Ogre::Associate.start(args)
    end
  end

end

#rubocop:enable LineLength
