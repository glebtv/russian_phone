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
  gem.homepage      = "https://github.com/glebtv/russian_phone"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]



  gem.add_development_dependency 'mongoid', '>= 3.0.0'
  gem.add_development_dependency "rails", ">= 3.0"
	gem.add_development_dependency "rspec", "~> 2.14.0"
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency "rspec-rails", "~> 2.14"
  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'database_cleaner'
end

