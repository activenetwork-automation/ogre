require 'thor'
require 'ogre/messages'
require 'ogre/create'
require 'ogre/config'
require 'ogre/associate'

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
    register(Ogre::Create, 'create', 'create ' << Ogre::Create.arguments.map(&:name).join(" ").upcase, DESC_CREATE)
    register(Ogre::Associate, 'associate', 'associate ' << Ogre::Associate.arguments.map(&:name).join(" ").upcase, DESC_ASSOCIATE_USERS)

    # hack to include options in 'ogre help command'
    tasks["create"].options = Ogre::Create.class_options
    tasks["associate"].options = Ogre::Associate.class_options

  end
end
