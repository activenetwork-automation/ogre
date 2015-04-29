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

describe Ogre::UserCreate do
  it 'should create new user' do
    args = %w(user first-name last-name user@exmaple.com password123) + DEFAULTS
    response = "'user' has been created.\n"
    VCR.use_cassette('user-create') do
      expect { Ogre::UserCreate.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail user exists' do
    args = %w(user first-name last-name user@exmaple.com password123) + DEFAULTS
    response = "'user' already exists.\n"
    VCR.use_cassette('user-create-exists') do
      expect { Ogre::UserCreate.start(args) }.to output(response).to_stdout
    end
  end

  it 'should fail password too short' do
    args = %w(user first-name last-name user@exmaple.com a) + DEFAULTS
    VCR.use_cassette('user-create-short-password') do
      begin
        Ogre::UserCreate.start(args)
      rescue Net::HTTPServerException => e
        response = JSON.parse(e.response.body)
        expect(response['error']).to eq(['Password must have at least 6 characters'])
      end
    end
  end

  it 'should fail bad email' do
    args = %w(user first-name last-name userexmaple.com password123) + DEFAULTS
    VCR.use_cassette('user-create-bad-email') do
      begin
        Ogre::UserCreate.start(args)
      rescue Net::HTTPServerException => e
        response = JSON.parse(e.response.body)
        expect(response['error']).to eq(['email must be valid'])
      end
    end
  end

end


