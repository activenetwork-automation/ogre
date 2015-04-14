require 'chef/rest'
require 'highline/import'

module Ogre
  class DeleteOrg < Ogre::Base
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG

    class_option :force, :aliases => '-f', :default => false, type: :boolean, desc: DESC_FORCE

      def delete_org

        # prompt user
        exit unless options[:force] || HighLine.agree("Deleting '#{org}' is permanent. Do you want to proceed? (y/n)")

        begin
          self.chef_rest.delete_rest("/organizations/#{org}")
          puts "'#{org}' org has been deleted."
        rescue Net::HTTPServerException => e
          # does not exist, exit gracefully
          if e.response.code == '404'
            puts "#{org} org does not exist"
          else
            raise e
          end
        end

      end
  end
end
