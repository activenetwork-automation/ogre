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

describe Ogre::OrgList do
  it 'should list all organizations' do
    args = %w(--run_as pivotal) + DEFAULTS
    response = "a3\naa\nacl\nacm\nadp\naev\nag\nan\naohflnx\naonet"
    VCR.use_cassette('org-list') do
      expect { Ogre::OrgList.start(args) }.to output(/#{response}/).to_stdout
    end
  end
end
