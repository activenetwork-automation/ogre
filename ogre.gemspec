# rubocop:disable all
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ogre/version'

Gem::Specification.new do |spec|
  spec.name          = 'ogre'
  spec.version       = Ogre::VERSION
  spec.authors       = %w('Joe Nguyen')
  spec.email         = %w('joe.nguyen@activenetwork.com')
  spec.summary       = 'Automated generation of enterprise chef organizations'
  spec.description   = 'Command line tool to automate creation of chef orgs, chef policy repositories, and validation key integration with vco'
  spec.homepage      = 'https://github.com/activenetwork-automation/ogre'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.30.1'
  # spec.add_development_dependency 'aruba', '>= 0.6'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'coveralls', '>= 0.7.9'
  spec.add_development_dependency 'guard', '>= 2.10.0'
  spec.add_development_dependency 'guard-rubocop', '>= 1.1.0'
  # growl functionality in Guardfile depends on growl-notify
  spec.add_development_dependency 'growl', '>= 1.0'
  spec.add_development_dependency 'yard', '>= 0.8'
  spec.add_development_dependency 'webmock', '>= 1.21.0'
  spec.add_development_dependency 'vcr', '>= 2.9.3'

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'chef-dk', '~> 0.5.1'
  spec.add_dependency 'vcoworkflows', '~> 0.1.2'
end
# rubocop:enable all

# spec.add_development_dependency('chef')
# spec.add_development_dependency('knife-vsphere')
#
# spec.add_dependency('open4')
# spec.add_dependency('english')
