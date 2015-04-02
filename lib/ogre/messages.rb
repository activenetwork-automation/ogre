# string constants for interactive messages
# rubocop:disable LineLength
module Ogre
  # command descriptions
  DESC_VERSION              = 'Display gem version'
  DESC_CREATE               = 'Create an organization in Chef'
  DESC_ORG                  = 'Organization shortname'
  DESC_ORG_DESC             = 'Organization long name'
  DESC_PRIVATE_KEY          = 'Path to private key file'
  DESC_CHEF_SERVER_URL      = 'Chef Server URL i.e. https://chef.server.domain'
  DESC_SAVE_VALIDATION_KEY  = 'Save the validation key, defaults to false'
  DESC_ASSOCIATE_USERS      = 'Associate users to an organization'
  DESC_USER                 = 'User to associate'
  DESC_ASSOCIATE_ADMIN      = 'Add user to admin group within organization'
  DESC_REPO_LICENSE         = 'Chef policy repository license'
  DESC_REPO_AUTHORS         = 'Chef policy repoistory authors'
  DESC_REPO_EMAIL           = 'Chef policy repository e-mail'
end
# rubocop:enable LineLength
