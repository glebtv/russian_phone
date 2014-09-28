# coding: utf-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'simplecov'
require 'mongoid'
require 'active_record'
require 'database_cleaner'
require 'pry'
SimpleCov.start
require 'russian_phone'

Mongoid.configure do |config|
  ENV["MONGOID_ENV"] = "test"
  Mongoid.load!("spec/support/mongoid.yml")
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.define do
  self.verbose = false
  create_table :ar_users, force: true do |t|
    t.string :name
    t.string :phone
    t.string :validated_phone
  end
end
ActiveRecord::Base.send :include, RussianPhone::ActiveRecord

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

DatabaseCleaner.orm = "mongoid"

RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    ArUser.destroy_all
  end

  config.mock_with :rspec
end
