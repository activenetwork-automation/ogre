require 'chef/rest'

module Ogre
  # base ogre class
  class Base < Thor::Group
    include Thor::Actions

    # chef rest
    class_option :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    class_option :run_as, type: :string, desc: DESC_RUN_AS
    class_option :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # parameters passed in from cli will take precedence
    def chef_rest
      Chef::REST.new(options[:server_url] || Config.options[:server_url],
                     options[:run_as] || Config.options[:run_as],
                     options[:key_path] || Config.options[:key_path])
    end
  end
end
