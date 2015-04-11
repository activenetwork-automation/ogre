require 'fileutils'
require 'json'

module Ogre
  OGRE_HOME = "#{ENV['HOME']}/.ogre"
  CONFIG_PATH = "#{OGRE_HOME}/config"

  # read config
  conf_opts = (JSON.parse(File.read(CONFIG_PATH), symbolize_names: true) if File.exist?(CONFIG_PATH)) || {}

  RUN_AS_USER = conf_opts[:username]
  END_POINT = conf_opts[:endpoint]
  KEY_PATH = conf_opts[:key]

end
