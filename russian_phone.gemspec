# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'russian_phone/version'

Gem::Specification.new do |gem|
  gem.name          = "russian_phone"
  gem.version       = RussianPhone::VERSION
  gem.authors       = ["GlebTv"]
  gem.email         = ["glebtv@gmail.com"]
  gem.description   = %q{Russian Phone Numbers for Mongoid}
  gem.summary       = %q{Поле для хранения Российских телефонных номеров в Mongoid}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_runtime_dependency(%q<mongoid>, [">= 2.4.0"])
  gem.add_development_dependency(%q<rspec>, ["~> 2.12.0"])
  gem.add_development_dependency(%q<bundler>, [">= 1.1.0"])
  gem.add_development_dependency(%q<simplecov>, [">= 0.4.0"])
  gem.add_development_dependency(%q<database_cleaner>, ["~> 0.9.0"])
end
