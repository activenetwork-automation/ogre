require 'fileutils'

# This is a simple class that puts options from a config file
# into an accessible object
module Ogre
  # ogre home
  OGRE_HOME = "#{ENV['HOME']}/.ogre".freeze
  # config path
  CONFIG_PATH = "#{OGRE_HOME}/config.json".freeze
  # default chef policy repo
  REPO_URL = 'https://github.com/activenetwork-automation/code_generator'.freeze

  # Static method to make config parameters available
  class Config
    # Read in defaults from config file
    def self.options
      (JSON.parse(File.read(CONFIG_PATH), symbolize_names: true) if File.exist?(CONFIG_PATH)) || {}
    end
  end
end
