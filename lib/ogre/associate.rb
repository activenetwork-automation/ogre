require 'chef/rest'

module Ogre
  class Associate < Thor::Group
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG
    argument :user, type: :string, desc: DESC_USER
    argument :server_url, type: :string, desc: DESC_CHEF_SERVER_URL
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # optional
    class_option :admin, :aliases => '-a', type: :boolean, desc: DESC_ASSOCIATE_ADMIN

    def associate
      # define REST object
      chef_rest = Chef::REST.new(server_url, RUN_AS_USER, key_path)

      # associate (invite) user
      request_body = {:user => user}
      response = chef_rest.post_rest "organizations/#{org}/association_requests", request_body

      # add (force) user to org
      association_id = response["uri"].split("/").last
      chef_rest.put_rest "users/#{user}/association_requests/#{association_id}", { :response => 'accept' }

      # admin?
      groups = ['users']
      if options[:admin] then groups << 'admins' end

      # add user to group(s)
      groups.each do |groupname|
        group = chef_rest.get_rest "organizations/#{org}/groups/#{groupname}"
        body_hash = {
          :groupname => "#{groupname}",
          :actors => {
            "users" => group["actors"].concat([user]),
            "groups" => group["groups"]
          }
        }

        chef_rest.put_rest "organizations/#{org}/groups/#{groupname}", body_hash
      end

    end
  end
end
