require 'chef/rest'
require 'chef-dk/command/generator_commands/repo'
require 'git'

module Ogre
  class Create < Thor::Group
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :org_desc, type: :string, desc: DESC_ORG_DESC
    argument :server_url , type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # optional chef policy repo parameters
    class_option :create_repo, :aliases => '-p', type: :boolean, default: false, desc: DESC_CREATE_REPO
    class_option :license, :aliases => '-I', :default => 'apache2', type: :string, desc: DESC_REPO_LICENSE
    class_option :email, :aliases => '-m', type: :string, desc: DESC_REPO_EMAIL
    class_option :authors, :aliases => '-C', type: :string, desc: DESC_REPO_AUTHORS

    def create
      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      begin
        # create org
        org_json = { name: "#{org}", full_name: "#{org_desc}" }
        response = chef_rest.post_rest("/organizations", org_json)
        puts "'#{org}' org has been created."

        # use chef repo generate to create a chef policy repo
        if options[:create_repo]
          Dir.mkdir OGRE_HOME unless File.exists?(OGRE_HOME)
          generate_cmd = ChefDK::Command::GeneratorCommands::Repo.new(generate_params)
          generate_cmd.run
          File.open("#{OGRE_HOME}/#{org}-chef/.chef/#{response['clientname']}.pem", "w") do |f|
            f.print(response['private_key'])
          end
        else
          puts response['private_key']
        end

      rescue Net::HTTPServerException => e
        # already exists -- i will allow it
        if e.response.code == "409"
          puts "#{org} org already exists"
        else
          raise e
        end
      end
    end

    def generate_params
      # chef policy repository parameters
      generate_str = ["#{OGRE_HOME}/#{org}-chef"]

      generate_str << "-a"
      generate_str << "org=#{org}"
      generate_str << "-a"
      generate_str << "chef_server_url=#{server_url}"
      generate_str << '-g'
      generate_str << 'lib/ogre/skeletons/code_generator'
      if options[:license] then
        generate_str << "-I"
        generate_str << "#{options[:license]}"
      end
      if options[:email] then
        generate_str << "-m"
        generate_str << "#{options[:email]}"
      end
      if options[:authors] then
        generate_str << "-C"
        generate_str << "\"#{options[:authors]}\""
      end
    end

  end
end
