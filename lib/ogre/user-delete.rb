module Ogre
  class UserDelete < Ogre::Base
    include Thor::Actions

    # required
    argument :username, type: :string

    # optional
    class_option :force, aliases: '-f', default: false, type: :boolean, desc: DESC_FORCE

    def user_delete

      begin
        # prompt user
        exit unless  options[:force] || HighLine.agree("Deleting '#{username}' is permanent. Do you want to proceed? (y/n)")

        # disassociate from all orgs
        orgs = self.chef_rest.get_rest("users/#{username}/organizations")
        org_names = orgs.map {|o| o['organization']['name']}
        org_names.each do |org|
           puts chef_rest.delete_rest("organizations/#{org}/users/#{username}")
        end

        # delete user
        chef_rest.delete_rest("users/#{username}")
        puts "'#{username}' has been deleted."

      rescue Net::HTTPServerException => e
        # already exists -- i will allow it
        if e.response.code == '404'
          puts "'#{username}' not found."
        else
          raise e
        end
      end
    end
  end
end
