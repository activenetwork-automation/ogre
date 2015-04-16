# Ogre

This gem supports organization and user management for Enterprise Chef.

While this functionality already exists in [knife-opc](https://github.com/chef/knife-opc), we wanted to be able to create the chef policy repository as well and set the private key into vCenter Orchestrator all in one tool.

## Installation

`gem install ogre`

## Configuration

### ~/.ogre/config.json

All of the parameters here are optional and can be passed in and/or overriden at the CLI.  As of today, the `pivotal` user and it's key is the way to execute certain commands via the  [Chef API](https://docs.chef.io/api_chef_server.html).  The key can be found in `/etc/opscode/pivotal.pem` on the Enterprise Chef box.

``` json
{
   "run_as":"chef_username",
   "key_path":"/path/to/key.pem",
   "server_url":"https://chef.url",
   "vco_url":"https://vco.url:8281/",
   "vco_user": "domain\\user",
   "vco_password":"password",
   "vco_wf_name":"vco_workflow_name",
   "vco_verify_ssl":"false"
}

```

## Usage
`ogre org-create ORG ORG_DESC (options)`
---
- `-p`, `--create-repo` # Create Chef policy repository-
- `-I`, `--license=LICENSE` # Chef policy repository license
- `-m`, `--email=EMAIL` # Chef policy repository e-mail
- `-C`, `--authors=AUTHORS` # Chef policy repository authors

When using `-p`, Ogre will save the Chef policy repository as ~/.ogre/[organization-name]-chef, otherwise it will output the validator key for the new organization.

`ogre org-delete org (options)`
---
- `-f`, `--force`                  # Delete without confirmation

`ogre user-create (options)`
---
`ogre user-delete (options)`
---
`ogre associate (options)`
---
`ogre set-private-key (options)`
---
