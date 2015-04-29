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

describe Ogre::OrgDelete do
  it 'should delete org' do
    args = %w(my-org-name -f) + DEFAULTS
    response = "'my-org-name' org has been deleted.\n"
    VCR.use_cassette('org-delete') do
      expect { Ogre::OrgDelete.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail org doesnt exist' do
    args = %w(my-nonexistent-org -f) + DEFAULTS
    response = "my-nonexistent-org org does not exist\n"
    VCR.use_cassette('org-delete-no-org') do
      expect { Ogre::OrgDelete.start(args) }.to output(response).to_stdout
    end
  end

end

#rubocop:enable LineLength
