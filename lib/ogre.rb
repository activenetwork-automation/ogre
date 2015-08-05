require 'thor'
require 'highline/import'
require 'ogre/messages'
require 'ogre/config'
require 'ogre/base'
require 'ogre/associate'
require 'ogre/org-create'
require 'ogre/org-delete'
require 'ogre/org-list'
require 'ogre/org-show'
require 'ogre/set-private-key'
require 'ogre/user-create'
require 'ogre/user-delete'
require 'ogre/user-list'
require 'ogre/version'

module Ogre
  # Start of main CLI
  class CLI < Thor
    package_name 'ogre'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    # Display the version of `ogre`
    def version
      puts VERSION
    end

    # rubocop:disable LineLength
    # subcommand in Thor called as registered class
    register(OrgCreate, 'org_create', 'org-create ' << OrgCreate.arguments.map(&:name).join(' ').upcase, DESC_CREATE)
    register(OrgDelete, 'org_delete', 'org-delete ' << OrgDelete.arguments.map(&:name).join(' ').upcase, DESC_DELETE)
    register(OrgList, 'org_list', 'org-list ' << OrgList.arguments.map(&:name).join(' ').upcase, DESC_ORG_LIST)
    register(OrgShow, 'org_show', 'org-show ' << OrgShow.arguments.map(&:name).join(' ').upcase, DESC_ORG_SHOW)
    register(UserCreate, 'user_create', 'user-create ' << UserCreate.arguments.map(&:name).join(' ').upcase, DESC_CREATE_USER)
    register(UserDelete, 'user_delete', 'user-delete ' << UserDelete.arguments.map(&:name).join(' ').upcase, DESC_DELETE_USER)
    register(UserList, 'user_list', 'user-list ' << UserList.arguments.map(&:name).join(' ').upcase, DESC_USER_LIST)
    register(Associate, 'associate', 'associate ' << Associate.arguments.map(&:name).join(' ').upcase, DESC_ASSOCIATE_USERS)
    register(SetPrivateKey, 'set_private_key', 'set-private-key ' << SetPrivateKey.arguments.map(&:name).join(' ').upcase, DESC_SET_PRIVATE_KEY)
    # rubocop:enable LineLength

    # Workarounds to include options in 'ogre help command'
    tasks['user_create'].options = UserCreate.class_options
    tasks['user_delete'].options = UserDelete.class_options
    tasks['user_list'].options = UserList.class_options
    tasks['org_create'].options = OrgCreate.class_options
    tasks['org_delete'].options = OrgDelete.class_options
    tasks['org_list'].options = OrgList.class_options
    tasks['org_show'].options = OrgShow.class_options
    tasks['associate'].options = Associate.class_options
    tasks['set_private_key'].options = SetPrivateKey.class_options
  end
end
