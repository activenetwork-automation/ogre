require_relative '../spec_helper.rb'
require 'ogre'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # remove sensitive authentication information from the recording
  config.before_record do |interaction|
    headers = interaction.request.headers
    headers.keys.
      select { |k| k =~ /^X-Ops-(Authorization-|Content-Hash)/ }
      .each { |header| headers[header] = Array("{{#{header}}}") }
    headers['X-Ops-Userid'] = 'pivotal'
  end
end

describe Ogre::UserDelete do

  it 'should delete user' do
    args = %w(user -f) + DEFAULTS
    response = "'user' has been deleted.\n"
    VCR.use_cassette('user-delete') do
      expect { Ogre::UserDelete.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail user not found' do
    args = %w(unknown -f) + DEFAULTS
    response = "'unknown' not found.\n"
    VCR.use_cassette('user-delete-not-found') do
      expect { Ogre::UserDelete.start(args) }.to output(response).to_stdout
    end
  end

end


