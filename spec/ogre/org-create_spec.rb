require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
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

describe Ogre::OrgCreate do

  it 'should create new org' do
    args = %w(my-org-name my-org-desc --run_as pivotal) + DEFAULTS
    VCR.use_cassette('org-create') do
      Ogre::OrgCreate.start(args)
    end
  end

  it 'should create new org and save chef policy repository' do
    args = %w(my-org-name my-org-desc -p -P tmp) + DEFAULTS
    VCR.use_cassette('org-create') do
      Ogre::OrgCreate.start(args)
    end
  end

  it 'should create new org and save chef policy repository with parameters' do
    args = %w(my-org-name my-org-desc -p -P tmp -I mit -m email@exmaple.com -C Top-Chefs) + DEFAULTS
    VCR.use_cassette('org-create') do
      Ogre::OrgCreate.start(args)
    end
  end

  it 'should fail org exists' do
    args = %w(my-org-name my-org-desc) + DEFAULTS
    VCR.use_cassette('org-create-exists') do
      expect { Ogre::OrgCreate.start(args) }.to output("my-org-name org already exists\n").to_stdout
    end
  end

end

#rubocop:enable LineLength
