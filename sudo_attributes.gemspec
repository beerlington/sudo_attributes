# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sudo_attributes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Brown"]
  gem.email         = ["github@lette.us"]
  gem.description   = "Adds 'sudo' methods to update protected ActiveRecord attributes with mass assignment"
  gem.summary       = "Override ActiveRecord protected attributes with mass assignment"
  gem.homepage      = "http://github.com/beerlington/sudo_attributes"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sudo_attributes"
  gem.require_paths = ["lib"]
  gem.version       = SudoAttributes::VERSION

  gem.add_dependency('rails')

  gem.add_development_dependency('rspec-rails', '~> 2.10.0')
  gem.add_development_dependency('sqlite3', '~> 1.3.6')
end
