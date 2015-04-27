require_relative '../spec_helper.rb'
require 'ogre'

# rubocop:disable LineLength

# describe Ogre::Associate do
#
#   before(:each) do
#     stub_request(:post, "https://chef-test.dev.activenetwork.com/organizations/my-org-name/association_requests").
#     with(:body => "{\"user\":\"jnguyen\"}",
#          :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'18', 'Content-Type'=>'application/json', 'Host'=>'chef-test.dev.activenetwork.com:443', 'User-Agent'=>'Chef Client/12.2.1 (ruby-2.1.4-p265; ohai-8.2.0; x86_64-darwin12.0; +http://opscode.com)', 'X-Chef-Version'=>'12.2.1', 'X-Ops-Authorization-1'=>'mn8UfWZGcFFchKFUffFrLnHfols2Q/02l8Y+LWCY3Nq7RVcvu6Gk3E+eFcgr', 'X-Ops-Authorization-2'=>'9Tt+bvPuy+F0Pz8/K/JTWoYmmevJ6L1Db9GfTjm6IJHB9KepV1W2MV+CnWBk', 'X-Ops-Authorization-3'=>'WhoMpM3ZQ0IJKNswLd/7wyTBa3dyxFoPA32d0HFHFOqGY/B3KMTLEbsoS+Xv', 'X-Ops-Authorization-4'=>'EFahQvt1MMt4oiuZiYZyy0oFH5rghSZgZiuicQiwSdEbPO0yVqf9NtjmCHXQ', 'X-Ops-Authorization-5'=>'fzxzLz2xBgqygOmoM7PhZ4tPot2HI7ejLP5iJm4KHsKEXa/Rh7t9SU8Wslb+', 'X-Ops-Authorization-6'=>'uDBffsoWc3VIamIx0HHA2jNLslB+2ZYjebrE4qZtYA==', 'X-Ops-Content-Hash'=>'hdSd8cStM1W9mChVKjQT/DvM0HY=', 'X-Ops-Sign'=>'algorithm=sha1;version=1.0;', 'X-Ops-Timestamp'=>'2015-04-27T14:53:29Z', 'X-Ops-Userid'=>'pivotal', 'X-Remote-Request-Id'=>'62ae0569-cd4d-491a-ab80-0d86a824ea9a'}).
#     to_return(:status => 200, :body => "", :headers => {})
#   end
#
#   it 'a user with user group' do
#     args = %w(my-org-name jnguyen)
#     options = Ogre::Associate.start(args)
#     expect(options).to eq %w(associate my-org-name my-user)
#   end
#
# end
# rubocop:enable LineLength
