require 'chef/rest'

module Ogre
  class CreateUser < Thor::Group
    include Thor::Actions

    # required
    argument :username, type: :string
    argument :first_name, type: :string
    argument :last_name, type: :string
    argument :email, type: :string
    argument :password, type: :string
    argument :server_url , type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    def create_user
      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      begin
        # create user
        user_json = {
        :username =>     username,
        :first_name =>   first_name,
        :last_name =>    last_name,
        :display_name => "#{first_name} #{last_name}",
        :email =>        email,
        :password =>     password }

        response = chef_rest.post_rest("/users", user_json)

        puts "'#{username}' has been created."

        # TODO: print/save pem key?

      rescue Net::HTTPServerException => e
        # already exists -- i will allow it
        if e.response.code == "409"
          puts "'#{username}' already exists."
        else
          raise e
        end
      end
    end
  end
end
