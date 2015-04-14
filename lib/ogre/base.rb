module Ogre
  class Base < Thor::Group
    include Thor::Actions

    # chef rest
    class_option :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    class_option :run_as, type: :string, desc: DESC_RUN_AS
    class_option :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # parameters passed in from cli will take precedence
    def chef_rest
      Chef::REST.new(options[:server_url] || END_POINT,
                     options[:run_as] || RUN_AS_USER,
                     options[:key_path] || KEY_PATH)
    end
  end
end
