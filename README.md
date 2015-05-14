[![Stories in Ready](https://badge.waffle.io/activenetwork-automation/ogre.svg?label=ready&title=Ready)](http://waffle.io/activenetwork-automation/ogre)

[![Build Status](https://travis-ci.org/activenetwork-automation/ogre.svg)](https://travis-ci.org/activenetwork-automation/ogre)
[![Coverage Status](https://coveralls.io/repos/activenetwork-automation/ogre/badge.svg)](https://coveralls.io/r/activenetwork-automation/ogre)
[![Dependency Status](https://gemnasium.com/activenetwork-automation/ogre.svg)](https://gemnasium.com/activenetwork-automation/ogre)
[![Inline docs](http://inch-ci.org/github/activenetwork-automation/ogre.png?branch=master)](http://inch-ci.org/github/activenetwork-automation/ogre)
[![Gem Version](https://badge.fury.io/rb/ogre.svg)](http://badge.fury.io/rb/ogre)

# Ogre

This gem supports organization and user management for Enterprise Chef.

While this functionality already exists in [knife-opc](https://github.com/chef/knife-opc), we wanted to be able to create the chef policy repository as well and set the private key into vCenter Orchestrator all in one tool.

## Installation

`gem install ogre`

## Configuration

### ~/.ogre/config.json

All of the parameters here are optional and can be passed in and/or overriden at the CLI.  As of today, the `pivotal` user is the only user able to execute certain methods via the [Chef API](https://docs.chef.io/api_chef_server.html).  The key can be found in `/etc/opscode/pivotal.pem` on the Enterprise Chef box.

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
ogre org-create ORG DESCRIPTION (options)
---
- `-p`, `--create-repo` Create Chef policy repository
- `-P`, `--repo-path` Chef policy repo path
- `-I`, `--license=LICENSE` Chef policy repository license
- `-m`, `--email=EMAIL` Chef policy repository e-mail
- `-C`, `--authors=AUTHORS` Chef policy repository authors

When using `-p`, Ogre will save the Chef policy repository as ~/.ogre/ORG-chef, otherwise it will output the validator key for the new organization.

ogre org-delete ORG (options)
---
- `-f`, `--force` Delete without confirmation

ogre user-create USERNAME FIRST_NAME LAST_NAME EMAIL PASSWORD (options)
---

ogre user-delete USERNAME (options)
---
- `-f`, `--force` Delete without confirmation

ogre associate ORG USER (options)
---
- `-a`, `--admin` Add user to admin group within organization

ogre set-private-key CHEF_HOSTNAME CHEF_VALIDATOR_NAME KEY_PATH (options)
---

`set-private-key` is very opinionated to our needs.  We have a vco workflow called `Set Private Key` which takes in `CHEF_HOSTNAME`, `CHEF_VALIDATOR_NAME`, and `KEY_PATH`.  This is stored in Orchestrator so that our organzation has the correct permissions to bootstrap nodes.

- `--vco-url` vCenter Orchestrator URL
- `--vco-user` vCenter Orchestrator user
- `--vco-password` vCenter Orchestrator password
- `--vco-wf-name` vCenter Orchestrator workflow name
- `--vco-verify-ssl` vCenter Orchestrator verify ssl

## Contributing

1. Fork it ( https://github.com/activenetwork-automation/ogre/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### License and Authors

- [Joe Nguyen](https://github.com/joenguyen)

## License ##

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Copyright:**       | Copyright 2015 ACTIVE Network, LLC
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
