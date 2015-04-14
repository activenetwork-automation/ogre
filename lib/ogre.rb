require 'thor'
require 'ogre/base'
require 'ogre/associate'
require 'ogre/config'
require 'ogre/create-org'
require 'ogre/create-user'
require 'ogre/delete-org'
require 'ogre/delete-user'
require 'ogre/set-private-key'
require 'ogre/messages'

# Refer to README.md for use instructions
module Ogre

  # Start of main CLI
  class CLI < Thor

    package_name 'ogre'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    def version
      puts VERSION
    end

    # subcommand in Thor called as registered class
    register(Ogre::CreateOrg, 'create_org', 'create-org ' << Ogre::CreateOrg.arguments.map(&:name).join(' ').upcase, DESC_CREATE)
    register(Ogre::DeleteOrg, 'delete_org', 'delete-org ' << Ogre::DeleteOrg.arguments.map(&:name).join(' ').upcase, DESC_DELETE)
    register(Ogre::CreateUser, 'create_user', 'create-user ' << Ogre::CreateUser.arguments.map(&:name).join(' ').upcase, DESC_CREATE_USER)
    register(Ogre::DeleteUser, 'delete_user', 'delete-user ' << Ogre::DeleteUser.arguments.map(&:name).join(' ').upcase, DESC_DELETE_USER)
    register(Ogre::Associate, 'associate', 'associate ' << Ogre::Associate.arguments.map(&:name).join(' ').upcase, DESC_ASSOCIATE_USERS)
    register(Ogre::SetPrivateKey, 'set_private_key', 'set-private-key' << Ogre::SetPrivateKey.arguments.map(&:name).join(' ').upcase, DESC_SET_PRIVATE_KEY)

    # workaround to include options in 'ogre help command'
    tasks['create_user'].options = Ogre::CreateUser.class_options
    tasks['delete_user'].options = Ogre::DeleteUser.class_options
    tasks['create_org'].options = Ogre::CreateOrg.class_options
    tasks['delete_org'].options = Ogre::DeleteOrg.class_options
    tasks['associate'].options = Ogre::Associate.class_options
    tasks['set_private_key'].options = Ogre::SetPrivateKey.class_options
  end
end
