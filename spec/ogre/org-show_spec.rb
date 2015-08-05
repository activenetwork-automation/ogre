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

describe Ogre::OrgShow do
  it 'should list all users' do
    args = %w(my-test-org) + DEFAULTS
    VCR.use_cassette('org-show') do
      # rubocop:disable LineLength
      expect { Ogre::OrgShow.start(args) }.to output(/(06ea2683f8cd6e177771f32482b72ea3)|(my-test-org)|(test org)|(@pivotal)|(@ats-build)|(@ats-build)/).to_stdout
      # rubocop:enable LineLength
    end
  end
end
