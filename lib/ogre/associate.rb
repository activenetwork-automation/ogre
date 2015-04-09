require 'chef/rest'

module Ogre
  class Associate < Ogre::Base
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :user, type: :string, desc: DESC_USER

    # optional
    class_option :admin, :aliases => '-a', type: :boolean, desc: DESC_ASSOCIATE_ADMIN

    def associate

      begin
        # associate (invite) user
        request_body = {:user => user}
        response = chef_rest.post_rest "organizations/#{org}/association_requests", request_body

        # add (force) user to org
        association_id = response["uri"].split("/").last
        self.chef_rest.put_rest "users/#{user}/association_requests/#{association_id}", { :response => 'accept' }
      rescue Net::HTTPServerException => e
        # already exists -- i will allow it
        if e.response.code == "409"
          puts "User #{user} already associated with organization #{org}"
        else
          raise e
        end
      end

      # add to admin?
      groups = ['users']
      if options[:admin] then groups << 'admins' end

      # add user to group(s)
      groups.each do |groupname|
        group = chef_rest.get_rest "organizations/#{org}/groups/#{groupname}"
        # check if user is in group
        if group["actors"].include?(user) == false
          body_hash = {
            :groupname => "#{groupname}",
            :actors => {
              "users" => group["actors"].concat([user]),
              "groups" => group["groups"]
            }
          }
          chef_rest.put_rest "organizations/#{org}/groups/#{groupname}", body_hash
          puts "Succesfully added #{user} to #{groupname} in the #{org} org"
        end
      end
    end
  end
end
