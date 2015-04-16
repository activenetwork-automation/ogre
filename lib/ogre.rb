require 'thor'
require 'highline/import'
require 'ogre/messages'
require 'ogre/config'
require 'ogre/base'
require 'ogre/associate'
require 'ogre/org-create'
require 'ogre/org-delete'
require 'ogre/set-private-key'
require 'ogre/user-create'
require 'ogre/user-delete'

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
    register(OrgCreate, 'org_create', 'org-create ' << OrgCreate.arguments.map(&:name).join(' ').upcase, DESC_CREATE)
    register(OrgDelete, 'org_delete', 'org-delete ' << OrgDelete.arguments.map(&:name).join(' ').upcase, DESC_DELETE)
    register(UserCreate, 'user_create', 'user-create ' << UserCreate.arguments.map(&:name).join(' ').upcase, DESC_CREATE_USER)
    register(UserDelete, 'user_delete', 'user-delete ' << UserDelete.arguments.map(&:name).join(' ').upcase, DESC_DELETE_USER)
    register(Associate, 'associate', 'associate ' << Associate.arguments.map(&:name).join(' ').upcase, DESC_ASSOCIATE_USERS)
    register(SetPrivateKey, 'set_private_key', 'set-private-key ' << SetPrivateKey.arguments.map(&:name).join(' ').upcase, DESC_SET_PRIVATE_KEY)

    # workaround to include options in 'ogre help command'
    tasks['user_create'].options = UserCreate.class_options
    tasks['user_delete'].options = UserDelete.class_options
    tasks['org_create'].options = OrgCreate.class_options
    tasks['org_delete'].options = OrgDelete.class_options
    tasks['associate'].options = Associate.class_options
    tasks['set_private_key'].options = SetPrivateKey.class_options
  end
end
