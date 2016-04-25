$LOAD_PATH << '../../lib'

require 'coveralls'
require 'vcr'

DEFAULTS = %w(--run-as pivotal
              --key-path spec/fixtures/client_key/dummy.pem
              --server-url https://chef.server).freeze
VCO_DEFAULTS = %w(--vco-url https://vco.server:8281/
                  --vco-user user
                  --vco-password password
                  --vco-wf-name Set-Private-Key
                  --vco-verify-ssl false).freeze
KNIFE_PATH = 'tmp/my-org-name-chef/.chef/knife.rb'.freeze

Coveralls.wear!
