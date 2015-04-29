module Ogre
  # This is used to create a user in enterprise chef
  class UserCreate < Ogre::Base
    include Thor::Actions

    # required
    argument :username, type: :string
    argument :first_name, type: :string
    argument :last_name, type: :string
    argument :email, type: :string
    argument :password, type: :string

    # Create chef user
    def user_create
      # create user
      user_json = {
        username:     username,
        first_name:   first_name,
        last_name:    last_name,
        display_name: "#{first_name} #{last_name}",
        email:        email,
        password:     password
      }

      chef_rest.post_rest('/users', user_json)

      puts "'#{username}' has been created."

      # TODO: print/save pem key?

    rescue Net::HTTPServerException => e
      # already exists -- i will allow it
      if e.response.code == '409'
        puts "'#{username}' already exists."
      else
        raise e
      end
    end
  end
end
