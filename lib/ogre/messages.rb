# string constants for interactive messages
# rubocop:disable LineLength
module Ogre
  # command descriptions
  DESC_VERSION              = 'Display gem version'
  DESC_CREATE               = 'Create an organization in Chef'
  DESC_DELETE               = 'Delete an organization in Chef'
  DESC_ORG                  = 'Organization short name'
  DESC_ORG_DESC             = 'Organization long name'
  DESC_PRIVATE_KEY          = 'Path to private key file'
  DESC_CHEF_SERVER_URL      = 'Chef Server URL i.e. https://chef.server.domain'
  DESC_ASSOCIATE_USERS      = 'Associate users to an organization'
  DESC_USER                 = 'User'
  DESC_ASSOCIATE_ADMIN      = 'Add user to admin group within organization'
  DESC_REPO_LICENSE         = 'Chef policy repository license'
  DESC_REPO_AUTHORS         = 'Chef policy repository authors'
  DESC_REPO_EMAIL           = 'Chef policy repository e-mail'
  DESC_CREATE_REPO          = 'Create Chef policy repository'
  DESC_FORCE                = 'Delete without confirmation'
  DESC_CREATE_USER          = 'Create new chef user'
  DESC_DELETE_USER          = 'Delete and disassociate chef user'
  DESC_RUN_AS               = 'Chef user'
  DESC_VCO_URL              = 'vCenter Orchestrator URL'
  DESC_VCO_USER             = 'vCenter Orchestrator user'
  DESC_VCO_PASSWORD         = 'vCenter Orchestrator password'
  DESC_VCO_WF_NAME          = 'vCenter Orchestrator workflow name'
  DESC_SET_PRIVATE_KEY      = 'Set chef validation key for VCO'
  DESC_CHEF_HOSTNAME        = 'Chef hostname'
  DESC_CHEF_VALIDATOR       = 'Chef validator username'
end
# rubocop:enable LineLength
