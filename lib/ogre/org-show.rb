module Ogre
  class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
  end

  # Show org through Chef::REST object
  class OrgShow < Ogre::Base
    include Thor::Actions

    # required
    argument :org, type: :string, desc: DESC_ORG

    # Show org details
    def org_show
      begin
        # get org details
        results = chef_rest.get_rest("/organizations/#{org}")
        puts colorize('name:') + "         #{results['name']}"
        puts colorize('description:') + "  #{results['full_name']}"
        puts colorize('guid:') + "         #{results['guid']}"

        # get admins
        admins = chef_rest.get_rest("/organizations/#{org}/groups/admins")

        # get normal users
        users = chef_rest.get_rest("/organizations/#{org}/groups/users")

        # output admins with a '@' prefix
        admins['users'].each do |admin|
          if admins['users'][0] == admin then
            puts colorize('users') + "         @#{admin}"
          else
            puts "              @#{admin}"
          end
        end

        # output users that don't exist in the admin group
        ( users['users'] - admins['users'] ).each do |user|
          puts "              #{user}"
        end
      end
    end

    private
    # fancy it up
    def colorize(text); "\033[36m#{text}\033[0m"; end
  end
end
