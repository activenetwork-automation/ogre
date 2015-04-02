require 'chef/config'
require 'chef/log'
require 'chef/rest'
require 'fileutils'
require 'git'

module Ogre
  class Associate < Thor::Group
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :user, type: :string, desc: DESC_USER
    argument :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # optional
    class_option :admin, :aliases => '-a', type: :boolean, desc: DESC_ASSOCIATE_ADMIN

    def associate
      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      # associate user(s)

      # add user(s) to groups

    end
  end
end
