##############################################################################
# Test Multi-DB connection switching in rails ActiveRecord library
##############################################################################

require "logger"
require "minitest/autorun"
require "active_record"

require_relative "../lib/dbrole"
require_relative "../lib/dbrole/api"

DbRoleManager = DbRole::Manager.new
DbRoleManager.patch!
