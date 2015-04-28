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
    headers["X-Ops-Userid"] = 'pivotal'
  end
end

describe Ogre::OrgCreate do

  it 'should create new org' do
    args = %w(my-org-name my-org-desc --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette("org-create") do
      options = Ogre::OrgCreate.start(args)
    end
  end

  it 'should create new org and save chef policy repository' do
    args = %w(my-org-name my-org-desc -p -P tmp --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette('org-create') do
      options = Ogre::OrgCreate.start(args)
    end
  end

  it 'should create new org and save chef policy repository with parameters' do
    args = %w(my-org-name my-org-desc -p -P tmp -I mit -m email@exmaple.com -C Top-Chefs --run_as pivotal --key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
    VCR.use_cassette('org-create') do
      options = Ogre::OrgCreate.start(args)
    end
  end

end

#rubocop:enable LineLength
