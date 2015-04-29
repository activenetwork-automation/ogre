$LOAD_PATH << '../../lib'

require 'coveralls'
require 'vcr'

DEFAULTS     = %w(--key_path spec/fixtures/client_key/dummy.pem --server_url https://chef.server)
VCO_DEFAULTS = %w(--vco-url https://vco.server:8281/ --vco-user user \
                  --vco-password password --vco-wf-name Set-Private-Key)
KNIFE_PATH   = 'tmp/my-org-name-chef/.chef/knife.rb'

Coveralls.wear!
