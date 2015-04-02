require 'chef/config'
require 'chef/log'
require 'chef/rest'
require 'git'

module Ogre
  class Create < Thor::Group
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :org_desc, type: :string, desc: DESC_ORG_DESC
    argument :server_url , type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # optional
    class_option :associate, :aliases => '-a', type: :array, desc: DESC_ASSOCIATE_USERS

    # optional chef policy repo parameters
    class_option :create_repo, :aliases => '-p', type: :boolean, default: false, desc: DESC_CREATE_REPO
    class_option :license, :aliases => '-I', :default => 'apache2', type: :string, desc: DESC_REPO_LICENSE
    class_option :email, :aliases => '-m', type: :string, desc: DESC_REPO_EMAIL
    class_option :authors, :aliases => '-C', type: :string, desc: DESC_REPO_AUTHORS

    def create

      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      # temp -- cleanup
      begin
        puts chef_rest.delete_rest("/organizations/test")
      rescue
      end

      # create org
      org_json = { name: "#{org}", full_name: "#{org_desc}" }
      response = chef_rest.post_rest("/organizations", org_json)

      # use chef repo generate to create a chef policy repo
      if options[:create_repo]
        Dir.mkdir OGRE_HOME unless File.exists?(OGRE_HOME)
        puts gen_cmd = generate_cmd
        system `#{gen_cmd}`
        File.open("#{OGRE_HOME}/#{org}-chef/.chef/#{response['clientname']}.pem", "w") do |f|
          f.print(response['private_key'])
        end
      else
        puts response['private_key']
      end

      # associate user(s)

      # temp -- cleanup
      puts chef_rest.delete_rest("/organizations/test")
    end

    def generate_cmd
      generate_str = 'chef generate repo '

      # chef policy repository parameters
      generate_str << "-a org=#{org} "
      generate_str << "-a chef_server_url=#{server_url} "
      generate_str << '-g lib/ogre/skeletons/code_generator '

      if options[:license] then generate_str << "-I #{options[:license]} " end
      if options[:email] then generate_str << "-m #{options[:email]} " end
      if options[:authors] then generate_str << "-C \"#{options[:authors]}\" " end

      generate_str << " #{OGRE_HOME}/#{org}-chef"
    end
  end
end
