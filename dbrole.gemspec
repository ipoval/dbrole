# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dbrole/version'

Gem::Specification.new do |gem|
  gem.name          = "dbrole"
  gem.version       = DbRole::VERSION
  gem.authors       = ["Ivan Povalyukhin"]
  gem.email         = ["ivpovaly@microsoft.com"]
  gem.description   = %q{DbRole gem gives you connection switching between master and replica dbs.}
  gem.summary       = %q{DbRole gem gives you connection switching between master and replica dbs.}
  gem.homepage      = ""
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "activerecord", [">= 3.2", "< 4.0"]
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake", "~> 11.2.2"
  gem.add_development_dependency "minitest", "~> 5.0"
end
