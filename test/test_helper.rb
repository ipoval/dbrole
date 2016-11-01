####################################################################
# Test Multi-DB connection switching in rails ActiveRecord library #
####################################################################

require "logger"
require "minitest/autorun"
require "active_record"
require_relative "../lib/dbrole"
require_relative "../lib/dbrole/api"

require_relative "gem_test_setup"
require_relative "cases/shardA/import"
require_relative "cases/shardB/import"

DbRoleManager = DbRole::Manager.new
DbRoleManager.patch!

Minitest.after_run {
  GemTestSetup.finalize
}
