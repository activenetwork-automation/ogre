module Ogre
  # Show org through Chef::REST object
  class OrgShow < Ogre::Base
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG

    # Show org details
    def org_show
      # get org details
      results = chef_rest.get("/organizations/#{org}")
      puts colorize('name:') + "         #{results['name']}"
      puts colorize('description:') + "  #{results['full_name']}"
      puts colorize('guid:') + "         #{results['guid']}"

      # get admins
      admins = chef_rest.get("/organizations/#{org}/groups/admins")

      # get normal users
      users = chef_rest.get("/organizations/#{org}/groups/users")

      # output admins with a '@' prefix
      admins['users'].each do |admin|
        if admins['users'][0] == admin
          puts colorize('users') + "         @#{admin}"
        else
          puts "              @#{admin}"
        end
      end

      # output users that don't exist in the admin group
      (users['users'] - admins['users']).each do |user|
        puts "              #{user}"
      end
    end

    private

    # fancy it up
    def colorize(text)
      "\033[36m#{text}\033[0m"
    end
  end
end
