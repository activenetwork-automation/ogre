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
      select { |k| k =~ /^X-Ops-(Authorization-|Content-Hash)/ }
      .each { |header| headers[header] = Array("{{#{header}}}") }
    headers['X-Ops-Userid'] = 'pivotal'
  end
end

describe Ogre::Associate do

  it 'should associate user to org' do
    args = %w(my-org-name test) + DEFAULTS
    VCR.use_cassette('associate', match_requests_on: [:uri]) do
      response = "Successfully added 'test' to 'users' in the my-org-name org\n"
      expect { Ogre::Associate.start(args) }.to output(response).to_stdout
    end
  end

  it 'should associate user to users and admin group' do
    args = %w(my-org-name test -a) + DEFAULTS
    response = "Successfully added 'test' to 'users' in the my-org-name org\n" \
               "Successfully added 'test' to 'admins' in the my-org-name org\n"
    VCR.use_cassette('associate', match_requests_on: [:uri]) do
      expect { Ogre::Associate.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail user already exists' do
    args = %w(my-org-name test) + DEFAULTS
    response = "User 'test' already associated with organization 'my-org-name'\n"
    VCR.use_cassette('associate-user-exists', match_requests_on: [:uri]) do
      expect { Ogre::Associate.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail org does not exist' do
    args = %w(non-existent-org test) + DEFAULTS
    VCR.use_cassette('associate-no-org', match_requests_on: [:uri]) do
      begin
        Ogre::Associate.start(args)
      rescue Net::HTTPServerException => e
        response = JSON.parse(e.response.body)
        expect(response['error']).to eq(["organization 'non-existent-org' does not exist."])
      end
    end
  end

  it 'should fail user does not exist' do
    args = %w(my-org-name non-existent-user) + DEFAULTS
    VCR.use_cassette('associate-no-user', match_requests_on: [:uri]) do
      begin
        Ogre::Associate.start(args)
      rescue Net::HTTPServerException => e
        response = JSON.parse(e.response.body)
        expect(response['error']).to eq('Could not find user non-existent-user')
      end
    end
  end

end

#rubocop:enable LineLength
