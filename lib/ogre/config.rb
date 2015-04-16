require 'fileutils'

module Ogre
  # environment
  OGRE_HOME = "#{ENV['HOME']}/.ogre"
  CONFIG_PATH = "#{OGRE_HOME}/config.json"

  class Config
    def self.options
      (JSON.parse(File.read(CONFIG_PATH), symbolize_names: true) if File.exist?(CONFIG_PATH)) || {}
    end
  end

end
