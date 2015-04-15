require 'fileutils'
require 'json'

module Ogre
  # environment
  OGRE_HOME = "#{ENV['HOME']}/.ogre"
  CONFIG_PATH = "#{OGRE_HOME}/config"

  # read file
  conf_opts = (JSON.parse(File.read(CONFIG_PATH), symbolize_names: true) if File.exist?(CONFIG_PATH)) || {}

  # chef
  RUN_AS_USER = conf_opts[:username]
  END_POINT = conf_opts[:endpoint]
  KEY_PATH = conf_opts[:key]

  # vco
  VCO_URL = conf_opts[:vco_url]
  VCO_USER = conf_opts[:vco_user]
  VCO_PASSWORD = conf_opts[:vco_password]
  VCO_WF_NAME = conf_opts[:vco_wf_name]
  VCO_VERIFY_SSL = conf_opts[:verify_ssl]
end
