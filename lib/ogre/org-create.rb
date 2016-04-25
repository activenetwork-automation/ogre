require 'chef-dk/command/generator_commands/repo'
require 'git'

module Ogre
  # Create organization through Chef::REST with the option to create the
  # Chef policy repository
  class OrgCreate < Ogre::Base
    # rubocop:disable PerceivedComplexity, Metrics/CyclomaticComplexity
    # required parameters
    argument :org, type: :string, desc: DESC_ORG
    argument :org_desc, type: :string, desc: DESC_ORG_DESC

    # optional chef policy repo parameters
    class_option :create_repo, aliases: '-p', type: :boolean, default: false, desc: DESC_CREATE_REPO
    class_option :repo_path, aliases: '-P', type: :string, desc: DESC_REPO_PATH
    class_option :license, aliases: '-I', default: 'apache2', type: :string, desc: DESC_REPO_LICENSE
    class_option :email, aliases: '-m', type: :string, desc: DESC_REPO_EMAIL
    class_option :authors, aliases: '-C', type: :string, desc: DESC_REPO_AUTHORS
    class_option :repo_url, aliases: '-r', type: :string, desc: DESC_REPO_URL

    # organization create method
    def org_create
      org_json = { name: org.to_s, full_name: org_desc.to_s }
      response = chef_rest.post_rest('/organizations', org_json)
      puts "'#{org}' org has been created."

      # use chef repo generate to create a chef policy repo
      if options[:create_repo]
        # check for policy repo - order of precedence: cli, config.json, default
        repo_url = Config.options[:repo_url] ? Config.options[:repo_url] : REPO_URL
        repo_url = options[:repo_url] ? options[:repo_url] : repo_url

        # get the repository name -- dependant on short name w/out '.git'
        skeleton_repo_path = "#{OGRE_HOME}/policy_repo/#{repo_url.split('/').last}"

        # get policy repo
        get_chef_policy_repo(repo_url, skeleton_repo_path)

        # create parent dir for chef policy repo
        repo_path = options[:repo_path] ? options[:repo_path] : OGRE_HOME
        Dir.mkdir repo_path unless File.exist?(repo_path)

        # run cookbook generate
        generate_cmd = ChefDK::Command::GeneratorCommands::Repo.new(generate_params(repo_path, skeleton_repo_path))
        generate_cmd.run

        # write out pem file
        File.open("#{repo_path}/#{org}-chef/.chef/#{response['clientname']}.pem", 'w') do |f|
          f.print(response['private_key'])
        end

      else
        puts response['private_key']
      end

    rescue Net::HTTPServerException => e
      # already exists -- i will allow it
      if e.response.code == '409'
        puts "#{org} org already exists"
      else
        raise e
      end
    end

    private

    # clone policy skeleton, if exists, get latest
    def get_chef_policy_repo(repo_url, skeleton_repo_path)
      # check for existing
      if File.exist?(skeleton_repo_path)
        # update if exists
        local_repo = Git.open(skeleton_repo_path)
        local_repo.pull
      else
        # get new if doesn't exist
        Git.clone(repo_url, skeleton_repo_path)
      end
    end

    # concatenate parameters into a format ChefDK::Command::GeneratorCommands::Repo will accept
    def generate_params(parent_path, skeleton_repo_path)
      # chef policy repository parameters
      generate_str = ["#{parent_path}/#{org}-chef"]

      # org name
      generate_str << '-a'
      generate_str << "org=#{org}"

      # chef server url
      generate_str << '-a'
      generate_str << "chef_server_url=#{options[:server_url] || Config.options[:server_url]}"

      # generator skeleton
      generate_str << '-g'
      generate_str << skeleton_repo_path

      # optional license
      if options[:license]
        generate_str << '-I'
        generate_str << options[:license].to_s
      end

      # optional email
      if options[:email]
        generate_str << '-m'
        generate_str << options[:email].to_s
      end

      # optional authors
      if options[:authors]
        generate_str << '-C'
        generate_str << options[:authors].to_s
      end

      generate_str
    end
  end
end

# rubocop:enable PerceivedComplexity, Metrics/CyclomaticComplexity
