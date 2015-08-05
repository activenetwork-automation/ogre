module Ogre
  # List organizations through Chef::REST object
  class OrgList < Ogre::Base
    include Thor::Actions

    # Organizations list
    def org_list
      results = chef_rest.get_rest('/organizations')
      puts results.keys.sort { |a, b| a <=> b }
    end
  end
end
