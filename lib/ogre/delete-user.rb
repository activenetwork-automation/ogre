require 'chef/rest'

module Ogre
  class DeleteUser < Thor::Group
    include Thor::Actions

    # required
    argument :username, type: :string
    argument :server_url , type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    def delete_user
      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      begin
        # prompt user
        exit unless HighLine.agree("Deleting '#{username}' is permanent. Do you want to proceed? (y/n)")

        # disassociate from all orgs
        orgs =  chef_rest.get_rest("users/#{username}/organizations")
        org_names = orgs.map {|o| o['organization']['name']}
        org_names.each do |org|
           puts chef_rest.delete_rest("organizations/#{org}/users/#{username}")
        end

        # delete user
        response = chef_rest.delete_rest("users/#{username}")
        puts "'#{username}' has been deleted."

      rescue Net::HTTPServerException => e
        # already exists -- i will allow it
        if e.response.code == "404"
          puts "'#{username}' not found."
        else
          raise e
        end
      end
    end
  end
end
