require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = %w(
    test/db_role_api_test.rb
    test/multi_db_test.rb
    test/multi_db_connection_test.rb
    test/shardB_multi_db_test.rb
  )
  t.verbose = true
end

task default: :test
