##############################################################################
# Test Multi-DB connection switching in rails ActiveRecord library
##############################################################################

begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

require "logger"
require "test/unit"
require "active_support"
require "active_support/test_case"
require "active_record"

require_relative "../lib/dbrole_api"
