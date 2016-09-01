# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbrole/version'

Gem::Specification.new do |gem|
  gem.name          = "dbrole"
  gem.version       = DbRole::VERSION
  gem.authors       = ["Ivan Povalyukhin"]
  gem.email         = ["ivpovaly@microsoft.com"]
  gem.description   = %q{DbRole gem gives you connection switching between master and replica db.}
  gem.summary       = %q{DbRole gem gives you connection switching between master and replica db.}
  gem.homepage      = "https://github.com/ipoval/dbrole"
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake", "~> 10.5"
  gem.add_development_dependency "rails", "3.2.22.4"
  gem.add_development_dependency "sqlite3"
end
