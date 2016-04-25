require_relative '../spec_helper.rb'
require 'ogre'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # remove sensitive authentication information from the recording
  config.before_record do |interaction|
    headers = interaction.request.headers
    headers.keys
           .select { |k| k =~ /^X-Ops-(Authorization-|Content-Hash)/ }
           .each { |header| headers[header] = Array("{{#{header}}}") }
    headers['X-Ops-Userid'] = 'pivotal'
  end
end

describe Ogre::UserList do
  it 'should list all users' do
    args = %w(--run_as pivotal) + DEFAULTS
    response = "ats-build\nberks-api\n"
    VCR.use_cassette('user-list') do
      expect { Ogre::UserList.start(args) }.to output(/#{response}/).to_stdout
    end
  end
end
