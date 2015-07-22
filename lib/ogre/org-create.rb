require 'chef-dk/command/generator_commands/repo'

module Ogre
  # Create organization through Chef::REST with the option to create the
  # Chef policy repository
  class OrgCreate < Ogre::Base
    # rubocop:disable PerceivedComplexity
    # required parameters
    argument :org, type: :string, desc: DESC_ORG
    argument :org_desc, type: :string, desc: DESC_ORG_DESC

    # optional chef policy repo parameters
    class_option :create_repo, aliases: '-p', type: :boolean, default: false, desc: DESC_CREATE_REPO
    class_option :repo_path, aliases: '-P', type: :string, desc: DESC_REPO_PATH
    class_option :license, aliases: '-I', default: 'apache2', type: :string, desc: DESC_REPO_LICENSE
    class_option :email, aliases: '-m', type: :string, desc: DESC_REPO_EMAIL
    class_option :authors, aliases: '-C', type: :string, desc: DESC_REPO_AUTHORS

    # organization create method
    def org_create
      org_json = { name: "#{org}", full_name: "#{org_desc}" }
      response = chef_rest.post_rest('/organizations', org_json)
      puts "'#{org}' org has been created."

      # use chef repo generate to create a chef policy repo
      if options[:create_repo]

        # create parent dir for chef policy repo
        repo_path = options[:repo_path] ? options[:repo_path] : OGRE_HOME
        Dir.mkdir repo_path unless File.exist?(repo_path)

        # run cookbook generate
        generate_cmd = ChefDK::Command::GeneratorCommands::Repo.new(generate_params(repo_path))
        generate_cmd.run

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

    # concatenate parameters into a format ChefDK::Command::GeneratorCommands::Repo will accept
    def generate_params(parent_path)
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
      generate_str << File.expand_path('../skeletons/code_generator', __FILE__)

      # optional license
      if options[:license]
        generate_str << '-I'
        generate_str << "#{options[:license]}"
      end

      # optional email
      if options[:email]
        generate_str << '-m'
        generate_str << "#{options[:email]}"
      end

      # optional authors
      if options[:authors]
        generate_str << '-C'
        generate_str << "#{options[:authors]}"
      end

      generate_str
    end
  end
end

# rubocop:enable PerceivedComplexity
