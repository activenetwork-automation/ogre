module Ogre
  # Delete organization through Chef::REST object
  class OrgDelete < Ogre::Base
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG

    class_option :force, aliases: '-f', default: false, type: :boolean, desc: DESC_FORCE

    # Organization delete
    def org_delete
      # prompt user
      exit unless options[:force] || HighLine.agree("Deleting '#{org}' is permanent. Do you want to proceed? (y/n)")

      begin
        chef_rest.delete("/organizations/#{org}")
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
