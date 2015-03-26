require 'chef/config'
require 'chef/log'
require 'chef/rest'
require 'fileutils'

module Ogre
  class Create < Thor::Group
    include Thor::Actions

    # required
    class_option :org, :aliases => '-n', :required => true, type: :string, desc: DESC_ORG
    class_option :org_desc, :aliases => '-d', :required => true, type: :string, desc: DESC_ORG_DESC
    class_option :server_url, :aliases => '-s', :required => true, type: :string, desc: DESC_CHEF_SERVER_URL
    class_option :key_path, :aliases => '-k', :required => true, type: :string, desc: DESC_PIVOTAL_KEY

    # optional
    class_option :save_key, :aliases => '-p', type: :boolean, default: false, desc: DESC_SAVE_VALIDATION_KEY
    class_option :associate, type: :array, desc: DESC_ASSOCIATE_USERS

    def create
      # define REST object
      chef_rest = Chef::REST.new(options[:server_url], RUN_AS_USER, options[:key_path])

      # temp -- cleanup
      begin
        puts chef_rest.delete_rest("/organizations/test")
      rescue
      end

      # create org
      org_json = {
        name: "#{options[:org]}",
        full_name: "#{options[:org_desc]}"
      }
      response = chef_rest.post_rest("/organizations", org_json)

      # TODO: use chef cookbook generate to create a platform-chef repository
      FileUtils.mkdir_p "#{ORGER_HOME}/#{options[:org]}-chef/.chef"

      # save validation key
      if options[:save_key]
        File.open("#{ORGER_HOME}/#{options[:org]}-chef/.chef/#{response['clientname']}.pem", "w") do |f|
          f.print(response['private_key'])
        end
      else
        puts response['private_key']
      end

      # associate user(s)

      # add user(s) to groups

      # temp -- cleanup
      puts chef_rest.delete_rest("/organizations/test")
    end
  end
end
