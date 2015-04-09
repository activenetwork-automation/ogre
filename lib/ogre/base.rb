module Ogre
  class Base < Thor::Group
    include Thor::Actions

    class_option :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    class_option :run_as, type: :string, desc: DESC_RUN_AS
    class_option :key_path, type: :string, desc: DESC_PRIVATE_KEY

    def chef_rest
      # define chef rest obj
      chef_rest = Chef::REST.new(options[:server_url] || END_POINT,
                                 options[:run_as] || RUN_AS_USER,
                                 options[:key_path] || KEY_PATH)
    end
  end
end
