module Ogre
  # List users through Chef::REST object
  class UserList < Ogre::Base
    include Thor::Actions

    # Users list
    def org_list
      # pull down all users
      results = chef_rest.get('/users')
      puts results.keys.sort { |a, b| a <=> b }
    end
  end
end
