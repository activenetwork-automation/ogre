require 'chef/rest'

# Refer to README.md for use instructions
module Ogre
  # Base ogre class includes common parameters used to authenticate with Chef::REST
  class Base < Thor::Group
    include Thor::Actions

    # Chef Rest parameters
    class_option :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    class_option :run_as, type: :string, desc: DESC_RUN_AS
    class_option :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # Parameters passed in from cli will take precedence
    def chef_rest
      Chef::Config.node_name = options[:run_as] || Config.options[:run_as]
      Chef::Config.client_key = options[:key_path] || Config.options[:key_path]
      Chef::ServerAPI.new(options[:server_url] || Config.options[:server_url])
    end
  end
end
