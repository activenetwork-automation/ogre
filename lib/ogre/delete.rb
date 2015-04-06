require 'chef/config'
require 'chef/log'
require 'chef/rest'
require 'highline/import'

module Ogre
  class Delete < Thor::Group
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :server_url , type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    class_option :force, :aliases => '-f', type: :string, desc: DESC_FORCE

      def delete
        # define REST object
        chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

        # prompt user
        exit unless HighLine.agree("Deleting '#{org}' is permanent. Do you want to proceed? (y/n)")

        begin
          chef_rest.delete_rest("/organizations/test")
          puts "'#{org}' org has been deleted."
        rescue Net::HTTPServerException => e
          # does not exist, exit gracefully
          if e.response.code == "404"
            puts "#{org} org does not exist"
          else
            raise e
          end
        end

      end
  end
end
