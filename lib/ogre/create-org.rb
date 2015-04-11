require 'chef/rest'
require 'chef-dk/command/generator_commands/repo'

module Ogre
  class CreateOrg < Ogre::Base

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :org_desc, type: :string, desc: DESC_ORG_DESC

    # optional chef policy repo parameters
    class_option :create_repo, :aliases => '-p', type: :boolean, default: false, desc: DESC_CREATE_REPO
    class_option :license, :aliases => '-I', :default => 'apache2', type: :string, desc: DESC_REPO_LICENSE
    class_option :email, :aliases => '-m', type: :string, desc: DESC_REPO_EMAIL
    class_option :authors, :aliases => '-C', type: :string, desc: DESC_REPO_AUTHORS

    def create_org
      begin
        # create org
        org_json = { name: "#{org}", full_name: "#{org_desc}" }
        response = self.chef_rest.post_rest('/organizations', org_json)
        puts "'#{org}' org has been created."

        # use chef repo generate to create a chef policy repo
        if options[:create_repo]
          Dir.mkdir OGRE_HOME unless File.exists?(OGRE_HOME)
          generate_cmd = ChefDK::Command::GeneratorCommands::Repo.new(generate_params)
          generate_cmd.run
          File.open("#{OGRE_HOME}/#{org}-chef/.chef/#{response['clientname']}.pem", 'w') do |f|
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
    end

    def generate_params
      # chef policy repository parameters
      generate_str = ["#{OGRE_HOME}/#{org}-chef"]

      # org name
      generate_str << '-a'
      generate_str << "org=#{org}"

      # chef server url
      generate_str << '-a'
      generate_str << "chef_server_url=#{options[:server_url] || END_POINT}"

      # generator skeleton
      generate_str << '-g'
      generate_str << 'lib/ogre/skeletons/code_generator'

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
        generate_str << "\"#{options[:authors]}\""
      end

      generate_str
    end

  end
end
