module Ogre
  # This is used to delete a user from enterprise chef
  class UserDelete < Ogre::Base
    include Thor::Actions

    # required
    argument :username, type: :string

    # optional
    class_option :force, aliases: '-f', default: false, type: :boolean, desc: DESC_FORCE

    # Delete user from enterprise chef
    def user_delete
      # prompt user
      # rubocop:disable LineLength
      exit unless options[:force] || HighLine.agree("Deleting '#{username}' is permanent. Do you want to proceed? (y/n)")
      # rubocop:enable LineLength

      # disassociate from all orgs
      orgs = chef_rest.get("users/#{username}/organizations")
      org_names = orgs.map { |o| o['organization']['name'] }
      org_names.each do |org|
        puts chef_rest.delete("organizations/#{org}/users/#{username}")
      end

      # delete user
      chef_rest.delete("users/#{username}")
      puts "'#{username}' has been deleted."

    rescue Net::HTTPServerException => e
      # user not found -- i will allow it
      if e.response.code == '404'
        puts "'#{username}' not found."
      else
        raise e
      end
    end
  end
end
