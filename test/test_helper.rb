##############################################################################
# Test Multi-DB connection switching in rails ActiveRecord library
##############################################################################

begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"
  gem "rails", "3.2.22.4"
  gem "sqlite3"
end

require "test/unit"
require "active_support"
require "active_support/test_case"
require "active_record"
require "logger"
require_relative "../lib/dbrole_api"
